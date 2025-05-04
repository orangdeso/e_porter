import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionReassignmentService {
  final FirebaseFirestore _firestore;
  Timer? _timer;
  bool _isRunning = false;

  TransactionReassignmentService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  void startService({int intervalSeconds = 30}) {
    log('[TransactionReassignmentService] Memulai service pengalihan transaksi dengan interval $intervalSeconds detik');
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (_) {
      _checkRejectedTransactions();
    });
  }

  void stopService() {
    _timer?.cancel();
    _timer = null;
    log('[TransactionReassignmentService] Service pengalihan transaksi dihentikan');
  }

  Future<void> _checkRejectedTransactions() async {
    // Mencegah eksekusi bersamaan
    if (_isRunning) {
      log('[TransactionReassignmentService] Proses pemeriksaan sebelumnya masih berjalan, melewati pemeriksaan ini');
      return;
    }

    _isRunning = true;
    try {
      log('[TransactionReassignmentService] Memeriksa transaksi yang ditolak...');

      // Query transaksi dengan status rejected di Firestore dengan kondisi yang lebih spesifik
      // PERUBAHAN: menghapus filter porterOnlineId null agar semua transaksi rejected bisa dideteksi
      final snapshot = await _firestore
          .collection('porterTransactions')
          .where('status', isEqualTo: 'rejected')
          .where('isRejected', isEqualTo: true)
          // .where('porterOnlineId', isNull: true) // DIHAPUS - tidak diperlukan dan dapat menyebabkan masalah
          .where('reassignmentInfo', isNull: true) // Belum pernah dialihkan
          .limit(5) // Batasi jumlah transaksi per batch
          .get();

      if (snapshot.docs.isEmpty) {
        log('[TransactionReassignmentService] Tidak ada transaksi ditolak yang perlu dialihkan');
        return;
      }

      log('[TransactionReassignmentService] Ditemukan ${snapshot.docs.length} transaksi ditolak yang perlu dialihkan');

      // Proses setiap transaksi satu per satu
      for (final doc in snapshot.docs) {
        final transactionId = doc.id;
        await _reassignTransaction(transactionId, doc.data());

        // Berikan sedikit jeda untuk menghindari konflik
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Log setelah semua transaksi diproses
      log('[TransactionReassignmentService] Selesai memproses ${snapshot.docs.length} transaksi ditolak');
    } catch (e) {
      log('[TransactionReassignmentService] Error memeriksa transaksi ditolak: $e');
    } finally {
      _isRunning = false;
    }
  }

  Future<void> _reassignTransaction(String transactionId, Map<String, dynamic> txData) async {
    try {
      log('[TransactionReassignmentService] Memulai pengalihan transaksi: $transactionId');

      // 1. Cari porter yang tersedia
      final availablePorters = await _getAvailablePorters();
      if (availablePorters.isEmpty) {
        log('[TransactionReassignmentService] Tidak ada porter tersedia untuk transaksi: $transactionId');
        return;
      }

      // 2. Pilih porter berdasarkan FIFO (yang sudah online paling lama didahulukan)
      final newPorter = availablePorters.first;
      final newPorterId = newPorter['id'];
      final newPorterUserId = newPorter['userId'];
      final newPorterLocation = newPorter['locationPorter'];

      log('[TransactionReassignmentService] Porter baru dipilih: $newPorterId (userId: $newPorterUserId)');

      // Ambil nilai yang diperlukan dari data transaksi
      final passengerId = txData['idPassenger']?.toString() ?? '';
      final oldPorterUserId = txData['porterUserId']?.toString() ?? '';
      final now = DateTime.now();

      // Ambil alasan penolakan jika ada
      String rejectionReason = "Transaksi dialihkan otomatis";
      if (txData.containsKey('rejectionInfo') && txData['rejectionInfo'] is Map) {
        final rejInfo = txData['rejectionInfo'] as Map<String, dynamic>;
        if (rejInfo.containsKey('reason') && rejInfo['reason'].toString().isNotEmpty) {
          rejectionReason = "Dialihkan otomatis: ${rejInfo['reason']}";
        }
      }

      // 3. Update data transaksi
      log('[TransactionReassignmentService] Memperbarui data transaksi & porter dengan batch operation');

      // TAMBAHAN: Double-check porter masih tersedia
      final porterDoc = await _firestore.collection('porterOnline').doc(newPorterId).get();
      if (!porterDoc.exists || porterDoc.data() == null || porterDoc.data()!['isAvailable'] != true) {
        log('[TransactionReassignmentService] Porter $newPorterId tidak lagi tersedia, batalkan pengalihan');
        return;
      }

      // Membuat Batch Operation
      final batch = _firestore.batch();

      // 4. Update porter baru - Set porter tidak tersedia dan hubungkan dengan transaksi
      batch.update(_firestore.collection('porterOnline').doc(newPorterId), {
        'isAvailable': false,
        'idTransaction': transactionId,
        'idUser': passengerId,
        'onlineAt': now,
      });

      // 5. Update transaksi utama dengan info porter baru
      batch.update(_firestore.collection('porterTransactions').doc(transactionId), {
        'locationPorter': newPorterLocation,
        'porterOnlineId': newPorterId,
        'porterUserId': newPorterUserId,
        'status': 'pending',
        'updatedAt': now,
        'reassignmentInfo': {
          'previousPorterId': oldPorterUserId,
          'reason': rejectionReason,
          'timestamp': now,
          'isAutomatic': true
        },
        'rejectionInfo': FieldValue.delete(), // Hapus info penolakan
        'isRejected': false,
        'hasAssignedPorter': true,
      });

      // 6. HAPUS entri transaksi lama dari porter sebelumnya jika ada
      if (oldPorterUserId.isNotEmpty) {
        log('[TransactionReassignmentService] Menghapus referensi dari porter lama: $oldPorterUserId');
        final oldRef = _firestore
            .collection('porterTransactionsByUser')
            .doc(oldPorterUserId)
            .collection('transactions')
            .doc(transactionId);

        batch.delete(oldRef);
      }

      // 7. Buat entri baru di porterTransactionsByUser untuk porter baru
      if (newPorterUserId.isNotEmpty) {
        log('[TransactionReassignmentService] Membuat referensi baru untuk porter: $newPorterUserId');
        final newRef = _firestore
            .collection('porterTransactionsByUser')
            .doc(newPorterUserId)
            .collection('transactions')
            .doc(transactionId);

        batch.set(newRef, {
          'transactionId': transactionId,
          'createdAt': now,
          'status': 'pending',
          'updatedAt': now,
          'type': 'reassigned',
          'passengerId': passengerId,
          'reassigned': true,
          'previousPorterUserId': oldPorterUserId,
          'isAutomatic': true
        });
      }

      // 8. Update porterRejections jika ada
      final rejectionRef = _firestore
          .collection('porterRejections')
          .doc(oldPorterUserId)
          .collection('transactionPorterRejection')
          .doc(transactionId);
      final rejectionDoc = await rejectionRef.get();

      if (rejectionDoc.exists) {
        batch.update(rejectionRef, {
          'isReassigned': true,
          'reassignedAt': now,
          'newPorterId': newPorterId,
          'newPorterUserId': newPorterUserId,
          'automaticReassignment': true
        });
      }

      // 9. Commit batch
      await batch.commit();

      log('[TransactionReassignmentService] ✓ Transaksi $transactionId berhasil dialihkan ke porter baru: $newPorterId');
    } catch (e) {
      log('[TransactionReassignmentService] Error mengalihkan transaksi $transactionId: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _getAvailablePorters() async {
    try {
      log('[TransactionReassignmentService] Mencari porter yang tersedia...');

      // Query porter yang tersedia dan tidak sedang melayani transaksi
      final query = _firestore
          .collection('porterOnline')
          .where('isAvailable', isEqualTo: true)
          .orderBy('onlineAt', descending: false) // FIFO - yang online paling lama didahulukan
          .limit(10); // Ambil lebih banyak untuk filtering

      final snapshot = await query.get();

      log('[TransactionReassignmentService] Query menemukan ${snapshot.docs.length} porter online');

      final List<Map<String, dynamic>> availablePorters = [];

      for (final doc in snapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;

        // PERUBAHAN: filter tambahan untuk memastikan porter benar-benar tersedia
        if (data.containsKey('userId') &&
            data.containsKey('locationPorter') &&
            data['userId'] != null &&
            data['userId'].toString().isNotEmpty &&
            data['locationPorter'] != null &&
            (data['idTransaction'] == null || data['idTransaction'].toString().isEmpty) &&
            (data['idUser'] == null || data['idUser'].toString().isEmpty)) {
          availablePorters.add(data);
          log('[TransactionReassignmentService] Porter tersedia: ${doc.id}, userId: ${data['userId']}');
        } else {
          log('[TransactionReassignmentService] Porter tidak memenuhi syarat: ${doc.id}');
          if (data['idTransaction'] != null) {
            log('[TransactionReassignmentService] - Alasan: Sudah memiliki transaksi aktif');
          } else if (data['userId'] == null || data['userId'].toString().isEmpty) {
            log('[TransactionReassignmentService] - Alasan: Tidak memiliki userId valid');
          } else if (data['locationPorter'] == null) {
            log('[TransactionReassignmentService] - Alasan: Tidak memiliki lokasi porter');
          }
        }
      }

      if (availablePorters.isEmpty) {
        log('[TransactionReassignmentService] Peringatan: Tidak ada porter yang tersedia setelah validasi');
      } else {
        log('[TransactionReassignmentService] Berhasil menemukan ${availablePorters.length} porter valid tersedia');
      }

      return availablePorters;
    } catch (e) {
      log('[TransactionReassignmentService] Error mendapatkan porter tersedia: $e');
      return [];
    }
  }

  // Opsional: Mengirim notifikasi ke porter baru
  Future<void> _sendNotificationToNewPorter(
      String porterUserId, String transactionId, Map<String, dynamic> txData) async {
    try {
      // Implementasi notifikasi bisa ditambahkan di sini
      // Misal dengan Firebase Cloud Messaging atau menyimpan di collection notifications
    } catch (e) {
      log('[TransactionReassignmentService] Error mengirim notifikasi: $e');
    }
  }

  Future<void> forceReassignmentCheck() async {
    log('[TransactionReassignmentService] Memaksa pengecekan pengalihan transaksi');
    await _checkRejectedTransactions();
  }
}

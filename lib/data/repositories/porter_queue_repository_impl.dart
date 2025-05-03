import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/domain/repositories/porter_queue_repository.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/models/porter_queue_model.dart';

class PorterQueueRepositoryImpl implements PorterQueueRepository {
  final FirebaseFirestore _firestore;

  PorterQueueRepositoryImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  String _generateId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(7, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  Future<String> createPorterQueue(String userId, String locationPorter) async {
    try {
      log('[PorterRepository] Membuat antrian porter untuk userId: $userId');

      final existingPorter = await getPorterByUserId(userId);
      if (existingPorter != null) {
        log('[PorterRepository] Porter dengan userId: $userId sudah ada di antrian');

        if (!existingPorter.isAvailable) {
          await _firestore.collection('porterOnline').doc(existingPorter.id).update({
            'isAvailable': true,
            'idUser': null,
            'idTransaction': null,
            'onlineAt': FieldValue.serverTimestamp(),
          });
          log('[PorterRepository] Status porter diperbarui menjadi available');
        }

        return existingPorter.id!;
      }

      final porterData = PorterQueueModel(
        userId: userId,
        isAvailable: true,
        onlineAt: DateTime.now(),
        locationPorter: locationPorter,
      ).toJson();

      final docRef = await _firestore.collection('porterOnline').add(porterData);

      log('[PorterRepository] Berhasil membuat antrian porter dengan ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      log('[PorterRepository] Error membuat antrian porter: $e');
      throw Exception('Gagal membuat antrian porter: $e');
    }
  }

  @override
  Future<PorterQueueModel?> getPorterByUserId(String userId) async {
    try {
      final snapshot = await _firestore.collection('porterOnline').where('userId', isEqualTo: userId).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        return PorterQueueModel.fromJson(snapshot.docs.first.data(), docId: snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      log('[PorterRepository] Error mendapatkan porter by userId: $e');
      return null;
    }
  }

  @override
  Future<void> deletePorterQueue(String porterId) async {
    try {
      log('[PorterRepository] Menghapus antrian porter dengan ID: $porterId');

      // Periksa apakah porter sedang memiliki transaksi aktif
      final porterDoc = await _firestore.collection('porterOnline').doc(porterId).get();
      if (porterDoc.exists) {
        final data = porterDoc.data();
        if (data != null && data['idTransaction'] != null) {
          log('[PorterRepository] Porter memiliki transaksi aktif, tidak dapat dihapus');
          throw Exception('Porter sedang menangani transaksi, selesaikan transaksi terlebih dahulu');
        }
      }

      await _firestore.collection('porterOnline').doc(porterId).delete();

      log('[PorterRepository] Berhasil menghapus antrian porter dengan ID: $porterId');
    } catch (e) {
      log('[PorterRepository] Error menghapus antrian porter: $e');
      throw Exception('Gagal menghapus antrian porter: $e');
    }
  }

  @override
  Future<PorterQueueModel?> getNextAvailablePorter() async {
    try {
      log('[PorterRepository] Mencari porter yang tersedia...');

      final snapshot = await _firestore
          .collection('porterOnline')
          .where('isAvailable', isEqualTo: true)
          .orderBy('onlineAt', descending: false)
          .limit(1)
          .get()
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Waktu pencarian porter habis');
      });

      log('[PorterRepository] Query result: ${snapshot.docs.length} porters available');

      if (snapshot.docs.isNotEmpty) {
        final porter = PorterQueueModel.fromJson(snapshot.docs.first.data(), docId: snapshot.docs.first.id);
        log('[PorterRepository] Porter tersedia: ${porter.id}');
        return porter;
      }
      log('[PorterRepository] Tidak ada porter yang tersedia');
      return null;
    } catch (e) {
      log('[PorterRepository] Error mendapatkan porter tersedia: $e');
      return null;
    }
  }

  @override
  Future<bool> assignPorterToUser(String porterId, String userId, String transactionId) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        final porterDoc = await transaction.get(_firestore.collection('porterOnline').doc(porterId));

        if (!porterDoc.exists) {
          log('[PorterRepository] Porter tidak ditemukan');
          return false;
        }

        final porterData = porterDoc.data();
        if (porterData == null || porterData['isAvailable'] != true) {
          log('[PorterRepository] Porter tidak tersedia');
          return false;
        }

        transaction.update(_firestore.collection('porterOnline').doc(porterId), {
          'isAvailable': false,
          'idUser': userId,
          'idTransaction': transactionId,
        });

        log('[PorterRepository] Porter berhasil ditugaskan ke user: $userId');
        return true;
      });
    } catch (e) {
      log('[PorterRepository] Error menugaskan porter: $e');
      return false;
    }
  }

  Future<void> createPorterTransaction({
    required String porterTransactionId,
    required String porterId,
    required String passengerId,
    required String ticketId,
    required String transactionId,
    required String locationPassenger,
    required String locationPorter,
  }) async {
    try {
      log('[PorterRepository] Membuat transaksi porter: $porterTransactionId');

      final now = DateTime.now();
      final kodePorter = _generateId();

      // Dapatkan data porter lengkap dari dokumen porterOnline
      final porterDoc = await _firestore.collection('porterOnline').doc(porterId).get();
      if (!porterDoc.exists || porterDoc.data() == null) {
        throw Exception('Porter tidak ditemukan');
      }

      final porterData = porterDoc.data()!;
      final porterUserId = porterData['userId'] ?? '';
      final currentLocationPorter = porterData['locationPorter'] ?? locationPorter;

      if (porterUserId.isEmpty) {
        throw Exception('userId porter tidak ditemukan');
      }

      log('[PorterRepository] Menggunakan porterUserId: $porterUserId');

      // Gunakan Firestore Transaction untuk memastikan operasi atomic
      await _firestore.runTransaction((transaction) async {
        // Periksa ulang apakah porter sudah diklaim untuk transaksi ini
        final freshPorterDoc = await transaction.get(_firestore.collection('porterOnline').doc(porterId));

        // Cek apakah porter masih ada
        if (!freshPorterDoc.exists) {
          throw Exception('Porter tidak ditemukan');
        }

        final freshPorterData = freshPorterDoc.data();
        if (freshPorterData == null) {
          throw Exception('Data porter tidak valid');
        }

        // Kondisi valid: porter tersedia ATAU porter diklaim oleh transaksi yang sama
        final isAvailable = freshPorterData['isAvailable'] == true;
        final isAssignedToSameTransaction = freshPorterData['idTransaction'] == porterTransactionId ||
            freshPorterData['idTransaction'] == transactionId;

        if (!isAvailable && !isAssignedToSameTransaction) {
          throw Exception('Porter tidak tersedia atau sudah ditugaskan ke transaksi lain');
        }

        // Update status porter di Firestore
        if (isAvailable) {
          final porterDocRef = _firestore.collection('porterOnline').doc(porterId);
          transaction.update(porterDocRef, {
            'isAvailable': false,
            'idUser': passengerId,
            'idTransaction': porterTransactionId,
            'locationPorter': currentLocationPorter,
          });
        }

        // Simpan data transaksi utama di porterTransactions
        final firestoreTransactionData = {
          'id': porterTransactionId,
          'kodePorter': kodePorter,
          'porterOnlineId': porterId,
          'porterUserId': porterUserId,
          'idPassenger': passengerId,
          'ticketId': ticketId,
          'transactionId': transactionId,
          'status': 'pending',
          'locationPassenger': locationPassenger,
          'locationPorter': currentLocationPorter,
          'createdAt': Timestamp.fromDate(now),
          'updatedAt': Timestamp.fromDate(now),
        };

        final transactionDocRef = _firestore.collection('porterTransactions').doc(porterTransactionId);
        transaction.set(transactionDocRef, firestoreTransactionData);

        // PERUBAHAN: Buat entri di porterTransactionsByUser sebagai dokumen di Firestore
        // Simpan di porterTransactionsByUser/{porterUserId}/transactions/{transactionId}
        final indexDocRef = _firestore
            .collection('porterTransactionsByUser')
            .doc(porterUserId)
            .collection('transactions')
            .doc(porterTransactionId);

        transaction.set(indexDocRef, {
          'transactionId': porterTransactionId,
          'createdAt': Timestamp.fromDate(now),
          'updatedAt': Timestamp.fromDate(now),
          'status': 'pending',
          'type': 'original',
          'passengerId': passengerId,
        });
      });

      log('[PorterRepository] Transaksi porter berhasil dibuat di Firestore');
    } catch (e) {
      log('[PorterRepository] Error membuat transaksi porter: $e');
      throw Exception('Gagal membuat transaksi porter: $e');
    }
  }

  @override
  Future<void> completePorterAssignment(String porterId) async {
    try {
      // Dapatkan dokumen porter
      final porterDoc = await _firestore.collection('porterOnline').doc(porterId).get();
      if (porterDoc.exists) {
        final porterData = porterDoc.data();
        final transactionId = porterData?['idTransaction'];

        if (transactionId != null) {
          // Update status transaksi di Firestore
          await _firestore.collection('porterTransactions').doc(transactionId).update({
            'status': 'selesai',
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // Update status transaksi di Realtime DB
          final rtdb = FirebaseDatabase.instance.ref();
          await rtdb.child('porterTransactions/$transactionId').update({
            'status': 'selesai',
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });
        }

        // Reset status porter
        await _firestore.collection('porterOnline').doc(porterId).update({
          'isAvailable': true,
          'idUser': null,
          'idTransaction': null,
        });

        log('[PorterRepository] Tugas porter selesai, status diperbarui');
      }
    } catch (e) {
      log('[PorterRepository] Error menyelesaikan tugas porter: $e');
      throw Exception('Gagal menyelesaikan tugas porter: $e');
    }
  }

  @override
  Future<PorterQueueModel?> getPorterById(String porterId) async {
    try {
      log('[PorterRepository] Mendapatkan porter by ID: $porterId');

      final snapshot = await _firestore.collection('porterOnline').doc(porterId).get();

      if (snapshot.exists && snapshot.data() != null) {
        return PorterQueueModel.fromJson(snapshot.data()!, docId: snapshot.id);
      }

      log('[PorterRepository] Porter tidak ditemukan dengan ID: $porterId');
      return null;
    } catch (e) {
      log('[PorterRepository] Error mendapatkan porter by ID: $e');
      return null;
    }
  }

  @override
  Future<bool> checkConditionForPorter(String porterId) async {
    try {
      // Memeriksa apakah porter ada dan tidak memiliki transaksi aktif
      final porterDoc = await _firestore.collection('porterOnline').doc(porterId).get();

      if (!porterDoc.exists) {
        return false;
      }

      final data = porterDoc.data();
      if (data != null && data['idTransaction'] != null) {
        return false;
      }

      return true;
    } catch (e) {
      throw Exception('Gagal memeriksa kondisi porter: $e');
    }
  }

  @override
  Stream<PorterQueueModel?> watchPorterByUserId(String userId) {
    try {
      log('[PorterRepository] Memulai stream porter dengan userId: $userId');

      return _firestore
          .collection('porterOnline')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          log('[PorterRepository] Tidak ada porter dengan userId: $userId');
          return null;
        }

        final doc = snapshot.docs.first;
        log('[PorterRepository] Porter ditemukan dengan ID: ${doc.id}');
        return PorterQueueModel.fromJson(doc.data(), docId: doc.id);
      });
    } catch (e) {
      log('[PorterRepository] Error watching porter by userId: $e');
      throw Exception('Gagal memantau data porter: $e');
    }
  }
}

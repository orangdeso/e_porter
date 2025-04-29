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

  @override
  Future<void> createPorterTransaction(
      {required String porterTransactionId,
      required String porterId,
      required String passengerId,
      required String ticketId,
      required String transactionId,
      required String locationPassenger,
      required String locationPorter}) async {
    try {
      log('[PorterRepository] Membuat transaksi porter: $porterTransactionId');

      final now = DateTime.now().millisecondsSinceEpoch;
      final kodePorter = _generateId();

      // Dapatkan userId porter dari dokumen porterOnline
      final porterDoc = await _firestore.collection('porterOnline').doc(porterId).get();
      String porterUserId = '';

      if (porterDoc.exists && porterDoc.data() != null) {
        porterUserId = porterDoc.data()!['userId'] ?? '';
        log('[PorterRepository] Mendapatkan userId porter: $porterUserId');
      }

      if (porterUserId.isEmpty) {
        log('[PorterRepository] PERINGATAN: userId porter tidak ditemukan, menggunakan porterId: $porterId');
        porterUserId = porterId; // Fallback ke porterId jika userId tidak ditemukan
      }

      final data = {
        'kodePorter': kodePorter,
        'porterOnlineId': porterId,
        'porterUserId': porterUserId, // Tambahkan porterUserId dalam data transaksi
        'idPassenger': passengerId,
        'ticketId': ticketId,
        'transactionId': transactionId,
        'status': 'pending',
        'locationPassenger': locationPassenger,
        'locationPorter': locationPorter,
        'createdAt': now,
      };

      // 1. Update Firestore
      final batch = _firestore.batch();
      final porterDocId = _firestore.collection('porterOnline').doc(porterId);
      final txDoc = _firestore.collection('porterTransactions').doc(porterTransactionId);

      batch.update(porterDocId, {
        'isAvailable': false,
        'idUser': passengerId,
        'idTransaction': porterTransactionId,
        'locationPorter': locationPorter,
      });
      batch.set(txDoc, data);

      await batch.commit();
      log('[PorterRepository] Dokumen Firestore berhasil diperbarui');

      // 2. Simpan transaksi di Realtime Database
      final rtdb = FirebaseDatabase.instance.ref();

      // 2.1 Data transaksi utama
      await rtdb.child('porterTransactions/$porterTransactionId').set(data);
      log('[PorterRepository] Data transaksi utama disimpan di RTDB');

      // 2.2 Simpan referensi di porterHistory berdasarkan porterId (untuk kompatibilitas mundur)
      await rtdb.child('porterHistory/$porterId/$porterTransactionId').set({
        'timestamp': now,
        'transactionId': porterTransactionId,
      });
      log('[PorterRepository] Referensi disimpan di porterHistory/$porterId');

      // 2.3 Simpan referensi di porterHistory berdasarkan userId porter (baru)
      if (porterUserId != porterId && porterUserId.isNotEmpty) {
        await rtdb.child('porterHistory/$porterUserId/$porterTransactionId').set({
          'timestamp': now,
          'transactionId': porterTransactionId,
        });
        log('[PorterRepository] Referensi disimpan di porterHistory/$porterUserId');
      }

      // 2.4 Simpan referensi di passengerHistory
      await rtdb.child('passengerHistory/$passengerId/$porterTransactionId').set({
        'timestamp': now,
        'transactionId': porterTransactionId,
      });
      log('[PorterRepository] Referensi disimpan di passengerHistory/$passengerId');

      log('[PorterRepository] Transaksi porter berhasil dibuat');
    } catch (e) {
      log('[PorterRepository] Error membuat transaksi porter: $e');
      throw Exception('Gagal membuat transaksi porter: $e');
    }
  }

  // @override
  // Future<List<String>> getPorterTransactionIds(String porterId) async {
  //   try {
  //     final rtdb = FirebaseDatabase.instance.ref();
  //     final snapshot = await rtdb.child('porterHistory/$porterId').get();

  //     if (snapshot.exists && snapshot.value != null) {
  //       final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
  //       return data.keys.map((key) => key.toString()).toList();
  //     }

  //     return [];
  //   } catch (e) {
  //     log('[PorterRepository] Error getting porter transaction IDs: $e');
  //     return [];
  //   }
  // }

  // @override
  // Future<Map<String, dynamic>?> getPorterTransactionById(String transactionId) async {
  //   try {
  //     final rtdb = FirebaseDatabase.instance.ref();
  //     final snapshot = await rtdb.child('porterTransactions/$transactionId').get();

  //     if (snapshot.exists && snapshot.value != null) {
  //       return Map<String, dynamic>.from(snapshot.value as Map);
  //     }

  //     return null;
  //   } catch (e) {
  //     log('[PorterRepository] Error getting porter transaction: $e');
  //     return null;
  //   }
  // }

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

  // @override
  // Future<void> createPorterTransaction(
  //     {required String porterTransactionId,
  //     required String porterId,
  //     required String passengerId,
  //     required String ticketId,
  //     required String transactionId,
  //     required String locationPassenger,
  //     required String locationPorter}) async {
  //   final now = FieldValue.serverTimestamp();
  //   final kodePorter = _generateId();

  //   final data = {
  //     'kodePorter': kodePorter,
  //     'porterOnlineId': porterId,
  //     'idPassenger': passengerId,
  //     'ticketId': ticketId,
  //     'transactionId': transactionId,
  //     'status': 'pending',
  //     'locationPassenger': locationPassenger,
  //     'locationPorter': locationPorter,
  //     'createdAt': now,
  //   };

  //   final batch = _firestore.batch();
  //   final porterDoc = _firestore.collection('porterOnline').doc(porterId);
  //   final txDoc = _firestore.collection('porterTransactions').doc(porterTransactionId);

  //   batch.update(porterDoc, {
  //     'isAvailable': false,
  //     'idUser': passengerId,
  //     'idTransaction': porterTransactionId,
  //     'locationPorter': locationPorter,
  //   });
  //   batch.set(txDoc, data);

  //   await batch.commit();

  //   // tulis juga ke Realtime Database agar porter bisa listen secara real-time
  //   final rtdb = FirebaseDatabase.instance.ref();
  //   await rtdb.child('porterTransactions/$porterId/$porterTransactionId').set({
  //     ...data,
  //     'createdAt': DateTime.now().millisecondsSinceEpoch,
  //   });
  // }

  // @override
  // Future<void> completePorterAssignment(String porterId) async {
  //   try {
  //     await _firestore.collection('porterOnline').doc(porterId).update({
  //       'isAvailable': true,
  //       'idUser': null,
  //       'idTransaction': null,
  //     });

  //     log('[PorterRepository] Tugas porter selesai, status diperbarui');
  //   } catch (e) {
  //     log('[PorterRepository] Error menyelesaikan tugas porter: $e');
  //     throw Exception('Gagal menyelesaikan tugas porter: $e');
  //   }
  // }

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

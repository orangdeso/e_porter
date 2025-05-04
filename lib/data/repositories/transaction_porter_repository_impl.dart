import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/models/transaction_porter_model.dart';
import '../../domain/repositories/transaction_porter_repository.dart';

class TransactionPorterRepositoryImpl implements TransactionPorterRepository {
  final FirebaseFirestore _firestore;

  TransactionPorterRepositoryImpl({FirebaseDatabase? database, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<PorterTransactionModel>> watchPorterTransactionsByUserId(String userId) {
    log('[PorterRepository] Memulai streaming transaksi berdasarkan userId: $userId');

    final controller = StreamController<List<PorterTransactionModel>>();

    try {
      // 1. Pantau koleksi transactions di bawah porterTransactionsByUser/{userId}
      final subscription = _firestore
          .collection('porterTransactionsByUser')
          .doc(userId)
          .collection('transactions')
          .snapshots()
          .listen((snapshot) async {
        try {
          log('[PorterRepository] Mendapatkan ${snapshot.docs.length} referensi transaksi');
          final futures = <Future<PorterTransactionModel?>>[];

          for (var doc in snapshot.docs) {
            final transactionId = doc.data()['transactionId']?.toString() ?? '';

            if (transactionId.isNotEmpty) {
              futures.add(_getTransactionDetailFromFirestore(transactionId));
            }
          }

          final results = await Future.wait(futures);
          final transactionList = results.where((tx) => tx != null).cast<PorterTransactionModel>().toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          controller.add(transactionList);
          log('[PorterRepository] Berhasil mengirim ${transactionList.length} transaksi untuk userId: $userId');
        } catch (e) {
          log('[PorterRepository] Error memproses stream: $e');
          controller.addError(e);
        }
      }, onError: (e) {
        log('[PorterRepository] Error pada stream: $e');
        controller.addError(e);
      });

      // 6. Atur pembersihan resource saat stream ditutup
      controller.onCancel = () {
        subscription.cancel();
        log('[PorterRepository] Stream transaksi ditutup untuk userId: $userId');
      };
    } catch (e) {
      log('[PorterRepository] Error membuat stream: $e');
      controller.addError(e);
    }

    return controller.stream;
  }

  Future<PorterTransactionModel?> _getTransactionDetailFromFirestore(String transactionId) async {
    try {
      final doc = await _firestore.collection('porterTransactions').doc(transactionId).get();

      if (doc.exists && doc.data() != null) {
        final Map<dynamic, dynamic> dynamicData = {};
        doc.data()!.forEach((key, value) {
          dynamicData[key] = value;
        });

        return PorterTransactionModel.fromJson(dynamicData, transactionId);
      }
      return null;
    } catch (e) {
      log('[PorterRepository] Error mengambil detail transaksi $transactionId: $e');
      return null;
    }
  }

  Stream<List<PorterTransactionModel>> watchPorterTransactions(String porterId) {
    log('[PorterRepository] Memulai streaming transaksi porter untuk porterOnlineId: $porterId');
    final controller = StreamController<List<PorterTransactionModel>>();

    try {
      // Langkah 1: Dapatkan porterUserId dari porterOnlineId
      _firestore.collection('porterOnline').doc(porterId).get().then((porterDoc) {
        if (!porterDoc.exists || porterDoc.data() == null) {
          log('[PorterRepository] Porter dengan ID $porterId tidak ditemukan');
          controller.add([]);
          return;
        }

        final porterUserId = porterDoc.data()!['userId']?.toString() ?? '';
        if (porterUserId.isEmpty) {
          log('[PorterRepository] UserId tidak ditemukan untuk porter $porterId');
          controller.add([]);
          return;
        }

        log('[PorterRepository] Menemukan porterUserId: $porterUserId untuk porterOnlineId: $porterId');

        // Langkah 2: Pantau koleksi transactions berdasarkan porterUserId yang ditemukan
        final subscription = _firestore
            .collection('porterTransactionsByUser')
            .doc(porterUserId)
            .collection('transactions')
            .snapshots()
            .listen((snapshot) async {
          try {
            log('[PorterRepository] Mendapatkan ${snapshot.docs.length} referensi transaksi untuk porterUserId: $porterUserId');
            final futures = <Future<PorterTransactionModel?>>[];

            for (var doc in snapshot.docs) {
              final transactionId = doc.data()['transactionId']?.toString() ?? '';

              if (transactionId.isNotEmpty) {
                futures.add(_getTransactionDetailFromFirestore(transactionId));
              }
            }

            final results = await Future.wait(futures);
            final transactionList = results.where((tx) => tx != null).cast<PorterTransactionModel>().toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            controller.add(transactionList);
            log('[PorterRepository] Berhasil mengirim ${transactionList.length} transaksi untuk porter: $porterId');
          } catch (e) {
            log('[PorterRepository] Error memproses stream: $e');
            controller.addError(e);
          }
        }, onError: (e) {
          log('[PorterRepository] Error pada stream: $e');
          controller.addError(e);
        });

        controller.onCancel = () {
          subscription.cancel();
          log('[PorterRepository] Stream transaksi ditutup untuk porter: $porterId');
        };
      }).catchError((error) {
        log('[PorterRepository] Error mendapatkan porter data: $error');
        controller.addError(error);
      });
    } catch (e) {
      log('[PorterRepository] Error membuat stream: $e');
      controller.addError(e);
    }

    log('[PorterRepository] Meneruskan watchPorterTransactions ke watchPorterTransactionsByUserId: $porterId');
    return watchPorterTransactionsByUserId(porterId);
  }

  Stream<PorterTransactionModel?> watchTransactionById(String transactionId) {
    log('[PorterRepository] Memantau transaksi dengan ID: $transactionId');

    return _firestore.collection('porterTransactions').doc(transactionId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        try {
          // Konversi ke peta string-dinamis yang diperlukan oleh fromJson
          final Map<dynamic, dynamic> dynamicData = {};
          snapshot.data()!.forEach((key, value) {
            dynamicData[key] = value;
          });

          final txModel = PorterTransactionModel.fromJson(dynamicData, transactionId);
          log('[PorterRepository] Transaksi diperbarui: $transactionId, status: ${txModel.status}');
          return txModel;
        } catch (e) {
          log('[PorterRepository] Error mengubah data: $e');
          throw e;
        }
      } else {
        return null;
      }
    });
  }

  @override
  Future<PorterTransactionModel?> getTransactionById(String transactionId) async {
    try {
      log('[PorterRepository] Mengambil data transaksi: $transactionId');

      // Langsung gunakan Firestore saja
      final doc = await _firestore.collection('porterTransactions').doc(transactionId).get();

      if (doc.exists && doc.data() != null) {
        final Map<dynamic, dynamic> dynamicData = {};
        doc.data()!.forEach((key, value) {
          dynamicData[key] = value;
        });

        return PorterTransactionModel.fromJson(dynamicData, transactionId);
      }
      return null;
    } catch (e) {
      log('[PorterRepository] Error mengambil transaksi porter: $e');
      return null;
    }
  }

  Stream<List<PorterTransactionModel>> watchRejectedTransactionsByPorter(String porterUserId) {
    log('[PorterRepository] Memantau transaksi yang ditolak untuk porterUserId: $porterUserId');

    // Query dari subcollection
    return _firestore
        .collection('porterRejections')
        .doc(porterUserId)
        .collection('transactionPorterRejections')
        .snapshots()
        .map((snapshot) {
      final transactions = <PorterTransactionModel>[];
      final seenIds = <String>{};

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final transactionId = doc.id;

          // Skip jika ID sudah pernah diproses
          if (seenIds.contains(transactionId)) {
            log('[PorterRepository] Duplikasi ID ditemukan, skip: $transactionId');
            continue;
          }
          seenIds.add(transactionId);

          final transactionMap = {
            'id': transactionId,
            'kodePorter': data['kodePorter'] ?? '',
            'idPassenger': data['idPassenger'] ?? '',
            'locationPassenger': data['locationPassenger'] ?? '',
            'locationPorter': data['locationPorter'] ?? '',
            'porterOnlineId': data['porterOnlineId'] ?? '',
            'porterUserId': data['porterUserId'] ?? '',
            'transactionId': data['transactionId'] ?? '',
            'ticketId': data['ticketId'] ?? '',
            'status': 'rejected',
            'createdAt': data['createdAt'] ?? Timestamp.now(),
            'updatedAt': data['updatedAt'] ?? Timestamp.now(),
            'rejectionInfo': {
              'reason': data['reason'] ?? '',
              'timestamp': data['updatedAt'] ?? Timestamp.now(),
              'status': 'rejected',
            },
            'isReassigned': data['isReassigned'] ?? false,
            'reassignmentInfo': data['isReassigned'] == true
                ? {
                    'timestamp': data['reassignedAt'] ?? Timestamp.now(),
                    'newPorterId': data['newPorterId'] ?? '',
                    'newPorterUserId': data['newPorterUserId'] ?? '',
                  }
                : null,
          };

          final transaction = PorterTransactionModel.fromJson(transactionMap, transactionId);
          transactions.add(transaction);
        } catch (e) {
          log('[PorterRepository] Error parsing porterRejection doc: $e');
        }
      }

      transactions.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

      log('[PorterRepository] Total unique rejected transactions: ${transactions.length}');
      return transactions;
    });
  }

  @override
  Future<void> updateTransactionStatus({
    required String transactionId,
    required String status,
  }) async {
    try {
      final now = DateTime.now();

      // 1. Dapatkan data transaksi
      final txDoc = await _firestore.collection('porterTransactions').doc(transactionId).get();
      if (!txDoc.exists || txDoc.data() == null) {
        throw Exception('Transaksi tidak ditemukan');
      }

      final txData = txDoc.data()!;
      final porterUserId = txData['porterUserId']?.toString() ?? '';

      // 2. Mulai batch transaction
      final batch = _firestore.batch();

      // 3. Update transaksi utama
      batch.update(_firestore.collection('porterTransactions').doc(transactionId), {
        'status': status,
        'updatedAt': now,
      });

      // 4. Update indeks di porterTransactionsByUser jika ada porter user ID
      if (porterUserId.isNotEmpty) {
        final indexRef = _firestore
            .collection('porterTransactionsByUser')
            .doc(porterUserId)
            .collection('transactions')
            .doc(transactionId);

        batch.update(indexRef, {
          'status': status,
          'updatedAt': now,
        });
      }

      // 5. Commit batch
      await batch.commit();
      log('[PorterRepository] Berhasil memperbarui status transaksi: $transactionId menjadi $status');
    } catch (e) {
      log('[PorterRepository] Error memperbarui status transaksi: $e');
      throw Exception('Gagal memperbarui status transaksi: $e');
    }
  }

  Future<void> rejectTransaction({
    required String transactionId,
    required String reason,
  }) async {
    final now = DateTime.now();
    final batch = _firestore.batch();

    try {
      log('[PorterRepository] Menolak transaksi: $transactionId dengan alasan: $reason');

      // 1. Dapatkan data transaksi dari Firestore
      final txDoc = await _firestore.collection('porterTransactions').doc(transactionId).get();
      if (!txDoc.exists || txDoc.data() == null) {
        throw FirebaseException(plugin: 'PorterRepository', message: 'Transaksi tidak ditemukan');
      }

      final transactionData = txDoc.data()!;
      final String porterOnlineId = transactionData['porterOnlineId'] ?? '';
      if (porterOnlineId.isEmpty) {
        throw FirebaseException(plugin: 'PorterRepository', message: 'ID Porter tidak ditemukan pada transaksi');
      }

      final porterUserId = transactionData['porterUserId'] ?? '';
      if (porterUserId.isEmpty) {
        throw FirebaseException(plugin: 'PorterRepository', message: 'User ID Porter tidak ditemukan pada transaksi');
      }

      // 2. Update status porter di Firestore
      final porterRef = _firestore.collection('porterOnline').doc(porterOnlineId);
      batch.update(porterRef, {
        'idTransaction': null,
        'idUser': null,
        'isAvailable': true,
        'onlineAt': now,
      });

      // 3. Simpan riwayat penolakan di SUBCOLLECTION porterRejections
      final rejectionData = {
        'kodePorter': transactionData['kodePorter'] ?? '',
        'idPassenger': transactionData['idPassenger'] ?? '',
        'locationPassenger': transactionData['locationPassenger'] ?? '',
        'locationPorter': transactionData['locationPorter'] ?? '',
        'porterOnlineId': porterOnlineId,
        'porterUserId': porterUserId,
        'transactionId': transactionData['transactionId'] ?? '',
        'ticketId': transactionData['ticketId'] ?? '',
        'reason': reason,
        'status': 'rejected',
        'createdAt': transactionData['createdAt'],
        'updatedAt': now,
        'isReassigned': false
      };

      // PERUBAHAN: Simpan ke subcollection porterRejections
      final rejectionRef = _firestore
          .collection('porterRejections')
          .doc(porterUserId)
          .collection('transactionPorterRejections')
          .doc(transactionId);

      batch.set(rejectionRef, rejectionData);

      // 4. Update status transaksi utama dengan objek RejectionInfo
      final rejectionInfo = {'reason': reason, 'timestamp': now, 'status': 'rejected'};

      final txRef = _firestore.collection('porterTransactions').doc(transactionId);
      batch.update(txRef, {
        'updatedAt': now,
        'status': 'rejected',
        'rejectionInfo': rejectionInfo,
        'porterOnlineId': null,
        'porterUserId': null,
        'locationPorter': null,
        'isRejected': true
      });

      if (porterUserId.isNotEmpty) {
        final indexRef = _firestore
            .collection('porterTransactionsByUser')
            .doc(porterUserId)
            .collection('transactions')
            .doc(transactionId);

        batch.update(indexRef, {
          'status': 'rejected',
          'updatedAt': now,
        });
      }

      await batch.commit();
      log('[PorterRepository] Proses penolakan transaksi selesai');
    } catch (e) {
      log('[PorterRepository] Error menolak transaksi: ${e.toString()}');
      throw FirebaseException(plugin: 'PorterRepository', message: 'Gagal menolak transaksi: ${e.toString()}');
    }
  }

  Future<void> completePorterTransaction({
    required String transactionId,
    required String porterOnlineId,
  }) async {
    final now = DateTime.now();
    final batch = _firestore.batch();

    try {
      log('[PorterRepository] Menyelesaikan transaksi: $transactionId');

      // 1. Dapatkan data transaksi
      final txDoc = await _firestore.collection('porterTransactions').doc(transactionId).get();
      if (!txDoc.exists || txDoc.data() == null) {
        throw Exception('Transaksi tidak ditemukan');
      }

      final txData = txDoc.data()!;
      final porterUserId = txData['porterUserId']?.toString() ?? '';

      // 2. Update transaksi utama
      batch.update(_firestore.collection('porterTransactions').doc(transactionId), {
        'status': 'selesai',
        'updatedAt': now,
        'isRejected': false,
        'hasAssignedPorter': true,
      });

      // 3. Reset status porter
      batch.update(_firestore.collection('porterOnline').doc(porterOnlineId), {
        'idTransaction': null,
        'idUser': null,
        'isAvailable': true,
        'onlineAt': now,
      });

      // 4. Update indeks di porterTransactionsByUser
      if (porterUserId.isNotEmpty) {
        final indexRef = _firestore
            .collection('porterTransactionsByUser')
            .doc(porterUserId)
            .collection('transactions')
            .doc(transactionId);

        batch.update(indexRef, {
          'status': 'selesai',
          'updatedAt': now,
        });
      }

      // 5. Commit batch
      await batch.commit();

      log('[PorterRepository] Transaksi porter berhasil diselesaikan');
    } catch (e) {
      log('[PorterRepository] Error menyelesaikan transaksi porter: $e');
      throw Exception('Gagal menyelesaikan transaksi porter: $e');
    }
  }

  Future<String?> reassignRejectedTransaction({
    required String transactionId,
    String? newPorterId,
  }) async {
    final batch = _firestore.batch();

    try {
      log('[PorterRepository] Mencoba mengalihkan transaksi: $transactionId');

      // 1. Ambil data transaksi
      final txDoc = await _firestore.collection('porterTransactions').doc(transactionId).get();
      if (!txDoc.exists || txDoc.data() == null) {
        log('[PorterRepository] Transaksi tidak ditemukan: $transactionId');
        return null;
      }

      final txData = txDoc.data()!;

      // 2. Verifikasi status dan kondisi lainnya
      final status = txData['status']?.toString() ?? '';
      final hasRejectionInfo = txData.containsKey('rejectionInfo') && txData['rejectionInfo'] != null;
      final hasReassignmentInfo = txData.containsKey('reassignmentInfo') && txData['reassignmentInfo'] != null;

      if (hasReassignmentInfo) {
        log('[PorterRepository] Transaksi sudah pernah dialihkan: $transactionId');
        return null;
      }

      if (status.toLowerCase() != 'rejected' && !hasRejectionInfo) {
        log('[PorterRepository] Transaksi tidak dalam status rejected: $transactionId');
        return null;
      }

      // 3. Ambil informasi porter lama dari porterRejections - PERBAIKAN
      String oldPorterUserId = '';

      try {
        log('[PorterRepository] Mencari oldPorterUserId...');

        // METODE BARU: Gunakan query yang lebih efektif
        final snapshot = await _firestore
            .collectionGroup('transactions')
            .where('transactionId', isEqualTo: transactionId)
            .where('status', isEqualTo: 'rejected')
            .get();

        log('[PorterRepository] Hasil pencarian referensi: ${snapshot.docs.length}');

        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            final pathParts = doc.reference.path.split('/');
            if (pathParts.length >= 4 && pathParts[0] == 'porterTransactionsByUser') {
              final potentialUserId = pathParts[1];

              // Verifikasi dengan porterRejections
              final rejectionCheck = await _firestore
                  .collection('porterRejections')
                  .doc(potentialUserId)
                  .collection('transactionPorterRejections')
                  .doc(transactionId)
                  .get();

              if (rejectionCheck.exists) {
                final rejData = rejectionCheck.data()!;
                if (rejData['status'] == 'rejected' && rejData['isReassigned'] != true) {
                  oldPorterUserId = potentialUserId;
                  log('[PorterRepository] ✓ oldPorterUserId confirmed: $oldPorterUserId');
                  break;
                }
              }
            }
          }
        }
      } catch (e) {
        log('[PorterRepository] Error metode utama: $e');
      }

      // FALLBACK 1: Cari menggunakan collectionGroup untuk porterRejections
      if (oldPorterUserId.isEmpty) {
        log('[PorterRepository] Mencoba fallback dengan collectionGroup...');
        try {
          final rejectionSnapshot = await _firestore
              .collectionGroup('transactionPorterRejections')
              .where('status', isEqualTo: 'rejected')
              .where('isReassigned', isEqualTo: false)
              .limit(10)
              .get();

          for (var doc in rejectionSnapshot.docs) {
            if (doc.id == transactionId) {
              final pathParts = doc.reference.path.split('/');
              if (pathParts.length >= 4 && pathParts[0] == 'porterRejections') {
                oldPorterUserId = pathParts[1];
                log('[PorterRepository] ✓ oldPorterUserId dari path: $oldPorterUserId');
                break;
              }
            }
          }
        } catch (e) {
          log('[PorterRepository] Error fallback collectionGroup: $e');
        }
      }

      // FALLBACK 2: Jika masih kosong, cek dari transaksi utama
      if (oldPorterUserId.isEmpty) {
        // Kadang kala porterUserId belum di-set menjadi null
        final tempUserId = txData['porterUserId']?.toString() ?? '';
        if (tempUserId.isNotEmpty) {
          log('[PorterRepository] Menggunakan porterUserId dari transaksi: $tempUserId');
          oldPorterUserId = tempUserId;
        }
      }

      // FALLBACK 3: Pencarian manual iteratif (hanya jika benar-benar diperlukan)
      if (oldPorterUserId.isEmpty) {
        log('[PorterRepository] Melakukan pencarian manual...');
        try {
          final users = await _firestore.collection('porterRejections').get();

          for (var userDoc in users.docs) {
            final rejDoc = await _firestore
                .collection('porterRejections')
                .doc(userDoc.id)
                .collection('transactionPorterRejections')
                .doc(transactionId)
                .get();

            if (rejDoc.exists) {
              final data = rejDoc.data()!;
              if (data['status'] == 'rejected' && data['isReassigned'] != true) {
                oldPorterUserId = userDoc.id;
                log('[PorterRepository] ✓ oldPorterUserId manual: $oldPorterUserId');
                break;
              }
            }
          }
        } catch (e) {
          log('[PorterRepository] Error pencarian manual: $e');
        }
      }

      // Hasil akhir
      log('[PorterRepository] Final oldPorterUserId: "$oldPorterUserId"');

      // 4. Cari porter baru
      String selectedPorterId;
      String porterUserId;
      String porterLocation;

      if (newPorterId != null && newPorterId.isNotEmpty) {
        // Gunakan porter yang ditentukan
        final porterDoc = await _firestore.collection('porterOnline').doc(newPorterId).get();
        if (!porterDoc.exists || porterDoc.data() == null) return null;

        final porterData = porterDoc.data()!;
        if (porterData['isAvailable'] != true || porterData['idTransaction'] != null) return null;

        selectedPorterId = newPorterId;
        porterUserId = porterData['userId'] ?? '';
        porterLocation = porterData['locationPorter'] ?? '';
      } else {
        // Cari porter yang tersedia secara otomatis
        final portersSnapshot = await _firestore
            .collection('porterOnline')
            .where('isAvailable', isEqualTo: true)
            .orderBy('onlineAt', descending: false)
            .limit(1)
            .get();

        if (portersSnapshot.docs.isEmpty) return null;

        final newPorter = portersSnapshot.docs.first;
        selectedPorterId = newPorter.id;
        porterUserId = newPorter.data()['userId'] ?? '';
        porterLocation = newPorter.data()['locationPorter'] ?? '';
      }

      if (selectedPorterId.isEmpty || porterUserId.isEmpty) return null;

      final now = DateTime.now();
      String rejectionReason = "Transaksi dialihkan ke porter baru";

      // Ambil alasan penolakan jika ada
      if (hasRejectionInfo && txData['rejectionInfo'] is Map) {
        final rejInfo = txData['rejectionInfo'] as Map<String, dynamic>;
        if (rejInfo.containsKey('reason')) {
          rejectionReason = "Dialihkan: ${rejInfo['reason']}";
        }
      }

      // 5. Update porter baru
      batch.update(_firestore.collection('porterOnline').doc(selectedPorterId), {
        'isAvailable': false,
        'idTransaction': transactionId,
        'idUser': txData['idPassenger'] ?? '',
        'lastAssigned': now,
      });

      // 6. Update transaksi utama dengan format ReassignmentInfo
      batch.update(_firestore.collection('porterTransactions').doc(transactionId), {
        'locationPorter': porterLocation,
        'porterOnlineId': selectedPorterId,
        'porterUserId': porterUserId,
        'status': 'pending',
        'updatedAt': now,
        'reassignmentInfo': {
          'previousPorterId': oldPorterUserId,
          'reason': rejectionReason,
          'timestamp': now,
        },
        'rejectionInfo': FieldValue.delete(),
        'isRejected': false,
        'hasAssignedPorter': true,
      });

      // 7. HAPUS indeks lama dari porterTransactionsByUser
      if (oldPorterUserId.isNotEmpty) {
        log('[PorterRepository] Menghapus referensi porter lama: $oldPorterUserId');

        try {
          final oldIndexRef = _firestore
              .collection('porterTransactionsByUser')
              .doc(oldPorterUserId)
              .collection('transactions')
              .doc(transactionId);

          final oldIndexDoc = await oldIndexRef.get();

          if (oldIndexDoc.exists) {
            batch.delete(oldIndexRef);
            log('[PorterRepository] ✓ Referensi ditambahkan ke batch delete');
          } else {
            log('[PorterRepository] ! Referensi tidak ditemukan di porterTransactionsByUser');
          }
        } catch (e) {
          log('[PorterRepository] Error setting up old reference deletion: $e');
        }
      }

      // 8. Buat indeks baru
      batch.set(
          _firestore
              .collection('porterTransactionsByUser')
              .doc(porterUserId)
              .collection('transactions')
              .doc(transactionId),
          {
            'transactionId': transactionId,
            'createdAt': now,
            'status': 'pending',
            'updatedAt': now,
            'type': 'reassigned',
            'passengerId': txData['idPassenger'] ?? '',
            'reassigned': true,
            'previousPorterUserId': oldPorterUserId,
          });

      // 9. Update porterRejections
      try {
        if (oldPorterUserId.isNotEmpty) {
          final rejectionRef = _firestore
              .collection('porterRejections')
              .doc(oldPorterUserId)
              .collection('transactionPorterRejections')
              .doc(transactionId);

          final rejectionDoc = await rejectionRef.get();

          if (rejectionDoc.exists) {
            batch.update(rejectionRef, {
              'isReassigned': true,
              'reassignedAt': now,
              'newPorterId': selectedPorterId,
              'newPorterUserId': porterUserId,
            });
          } else {
            log('[PorterRepository] Dokumen porterRejections tidak ada di subcollection');
          }
        }
      } catch (e) {
        log('[PorterRepository] Error saat mengupdate porterRejections: $e');
      }

      // 10. Commit batch
      await batch.commit();

      // 11. TAMBAHAN: Verifikasi pembersihan
      if (oldPorterUserId.isNotEmpty) {
        await Future.delayed(Duration(milliseconds: 500)); // Berikan waktu untuk commit

        final verifyOldRef = await _firestore
            .collection('porterTransactionsByUser')
            .doc(oldPorterUserId)
            .collection('transactions')
            .doc(transactionId)
            .get();

        if (verifyOldRef.exists) {
          log('[PorterRepository] WARNING: Old reference masih ada, mencoba penghapusan manual');
          await verifyOldRef.reference.delete();
        } else {
          log('[PorterRepository] ✓ Old reference berhasil dihapus');
        }
      }

      log('[PorterRepository] Transaksi berhasil dialihkan: $transactionId');
      return transactionId;
    } catch (e) {
      log('[PorterRepository] Error mengalihkan transaksi: $e');
      return null;
    }
  }
}

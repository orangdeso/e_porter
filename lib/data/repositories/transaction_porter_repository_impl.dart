import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/models/transaction_porter_model.dart';
import '../../domain/repositories/transaction_porter_repository.dart';

class TransactionPorterRepositoryImpl implements TransactionPorterRepository {
  final FirebaseDatabase _database;
  final FirebaseFirestore _firestore;

  TransactionPorterRepositoryImpl({FirebaseDatabase? database, FirebaseFirestore? firestore})
      : _database = database ?? FirebaseDatabase.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<PorterTransactionModel>> watchPorterTransactions(String porterId) {
    log('[TransactionPorterRepo] Memulai streaming transaksi porter: $porterId');

    // Dapatkan dulu porterOnline document untuk mendapatkan userId
    return _firestore.collection('porterOnline').doc(porterId).snapshots().asyncMap((snapshot) async {
      String userId = '';
      if (snapshot.exists && snapshot.data() != null) {
        userId = snapshot.data()!['userId'] ?? '';
        log('[TransactionPorterRepo] Ditemukan userId: $userId untuk porterId: $porterId');
      } else {
        // Jika porterOnline tidak ditemukan, gunakan porterId sebagai userId (fallback)
        userId = porterId;
        log('[TransactionPorterRepo] Porter tidak ditemukan di porterOnline, menggunakan porterId sebagai userId: $userId');
      }

      // Gabungkan transaksi dari kedua sumber
      List<PorterTransactionModel> allTransactions = [];

      try {
        // 1. Ambil dari porterHistory berdasarkan userId
        if (userId.isNotEmpty) {
          log('[TransactionPorterRepo] Mengambil transaksi dari porterHistory/$userId');
          final snapshot = await _database.ref().child('porterHistory/$userId').get();
          if (snapshot.exists && snapshot.value != null) {
            final Map<dynamic, dynamic> historyData = snapshot.value as Map<dynamic, dynamic>;

            for (final entry in historyData.entries) {
              final transactionId = entry.key.toString();
              log('[TransactionPorterRepo] Memproses transactionId: $transactionId');

              final txData = await getPorterTransactionById(transactionId);
              if (txData != null) {
                log('[TransactionPorterRepo] Transaksi ditemukan, menambahkan ke daftar');
                allTransactions.add(PorterTransactionModel.fromJson(txData, transactionId));
              } else {
                log('[TransactionPorterRepo] Data transaksi tidak ditemukan untuk ID: $transactionId');
              }
            }

            log('[TransactionPorterRepo] Total ${allTransactions.length} transaksi dari porterHistory/$userId');
          } else {
            log('[TransactionPorterRepo] Tidak ada data di porterHistory/$userId');
          }
        }

        // 2. Juga ambil dari porterHistory berdasarkan porterId jika berbeda dari userId
        if (porterId != userId && porterId.isNotEmpty) {
          log('[TransactionPorterRepo] Mengambil transaksi dari porterHistory/$porterId');
          final snapshot = await _database.ref().child('porterHistory/$porterId').get();
          if (snapshot.exists && snapshot.value != null) {
            final Map<dynamic, dynamic> historyData = snapshot.value as Map<dynamic, dynamic>;

            for (final entry in historyData.entries) {
              final transactionId = entry.key.toString();
              // Cek apakah transaksi sudah ada di allTransactions
              if (!allTransactions.any((tx) => tx.id == transactionId)) {
                final txData = await getPorterTransactionById(transactionId);
                if (txData != null) {
                  allTransactions.add(PorterTransactionModel.fromJson(txData, transactionId));
                }
              }
            }

            log('[TransactionPorterRepo] Menambahkan transaksi dari porterHistory/$porterId');
          } else {
            log('[TransactionPorterRepo] Tidak ada data di porterHistory/$porterId');
          }
        }

        // 3. Cari transaksi yang memiliki porterUserId yang cocok dengan userId
        final List<String> additionalTransactionIds = [];
        final snapshotAll = await _database.ref().child('porterTransactions').get();
        if (snapshotAll.exists && snapshotAll.value != null) {
          final allTransactionsData = snapshotAll.value as Map<dynamic, dynamic>;

          allTransactionsData.forEach((key, value) {
            final transactionData = value as Map<dynamic, dynamic>;
            if (transactionData.containsKey('porterUserId') && transactionData['porterUserId'] == userId) {
              additionalTransactionIds.add(key.toString());
            }
          });

          log('[TransactionPorterRepo] Menemukan ${additionalTransactionIds.length} transaksi tambahan dengan porterUserId: $userId');

          for (final id in additionalTransactionIds) {
            if (!allTransactions.any((tx) => tx.id == id)) {
              final txData = await getPorterTransactionById(id);
              if (txData != null) {
                allTransactions.add(PorterTransactionModel.fromJson(txData, id));
              }
            }
          }
        }

        // Sort by date (newest first)
        allTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        log('[TransactionPorterRepo] Total ${allTransactions.length} transaksi gabungan berhasil dimuat');
        return allTransactions;
      } catch (e) {
        log('[TransactionPorterRepo] Error saat memproses data riwayat porter: $e');
        return <PorterTransactionModel>[];
      }
    });
  }

  @override
  Stream<PorterTransactionModel?> watchTransactionById(String transactionId) {
    log('[TransactionPorterRepo] Memantau transaksi dengan ID: $transactionId');

    // Buat controller stream untuk mengirimkan update
    final controller = StreamController<PorterTransactionModel?>();

    // Buat subscription terhadap node porterTransactions/{transactionId}
    final subscription = _database.ref().child('porterTransactions/$transactionId').onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        try {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          final txModel = PorterTransactionModel.fromJson(data, transactionId);
          controller.add(txModel);
          log('[TransactionPorterRepo] Transaksi diperbarui: $transactionId, status: ${txModel.status}');
        } catch (e) {
          log('[TransactionPorterRepo] Error mengubah data: $e');
          controller.addError(e);
        }
      } else {
        controller.add(null);
      }
    }, onError: (e) {
      log('[TransactionPorterRepo] Error streaming transaksi: $e');
      controller.addError(e);
    });

    // Tutup controller dan batalkan subscription ketika stream ditutup
    controller.onCancel = () {
      subscription.cancel();
      controller.close();
    };

    return controller.stream;
  }
  // @override
  // Future<PorterTransactionModel?> getTransactionById(String transactionId) async {
  //   try {
  //     log('Fetching transaction by ID from Firestore: $transactionId');

  //     // Coba cari langsung dengan transactionId di Firestore
  //     final docSnapshot = await _firestore.collection('porterTransactions').doc(transactionId).get();

  //     if (docSnapshot.exists) {
  //       log('Transaction found in Firestore with data: ${docSnapshot.data()}');
  //       final data = docSnapshot.data();
  //       if (data != null) {
  //         return PorterTransactionModel.fromJson(data, transactionId);
  //       }
  //     } else {
  //       log('Transaction not found in Firestore with direct ID: $transactionId');
  //     }

  //     // Jika tidak ada di Firestore, coba cari dengan format "ticketId-transactionId"
  //     if (transactionId.contains('-')) {
  //       log('Trying with direct ID format: $transactionId');
  //       final combinedDocSnapshot = await _firestore.collection('porterTransactions').doc(transactionId).get();

  //       if (combinedDocSnapshot.exists) {
  //         log('Transaction found in Firestore with combined ID');
  //         final data = combinedDocSnapshot.data();
  //         if (data != null) {
  //           return PorterTransactionModel.fromJson(data, transactionId);
  //         }
  //       }
  //     }

  //     log('Transaction not found in Firestore with any ID format. Final attempt with Realtime DB...');

  //     // Mencoba cari di semua porterTransactions nodes di Realtime DB (sebagai fallback)
  //     // Ini inefficient, tapi bisa membantu menemukan data jika struktur tidak konsisten
  //     final dbRef = _database.ref().child('porterTransactions');
  //     final dataSnapshot = await dbRef.get();

  //     if (dataSnapshot.exists && dataSnapshot.value is Map) {
  //       final allData = dataSnapshot.value as Map<dynamic, dynamic>;

  //       // Iterasi semua porter IDs
  //       for (var porterId in allData.keys) {
  //         final porterData = allData[porterId];

  //         if (porterData is Map<dynamic, dynamic> && porterData.containsKey(transactionId)) {
  //           log('Transaction found in Realtime DB under porter: $porterId');
  //           final transactionData = porterData[transactionId] as Map<dynamic, dynamic>;
  //           return PorterTransactionModel.fromJson(transactionData, transactionId);
  //         }
  //       }
  //     }

  //     log('Transaction not found with ID: $transactionId in any database');
  //     return null;
  //   } catch (e) {
  //     log('Error fetching transaction by ID: $e');
  //     return null;
  //   }
  // }

  @override
  Future<PorterTransactionModel?> getTransactionById(String transactionId) async {
    try {
      final txData = await getPorterTransactionById(transactionId);
      if (txData != null) {
        return PorterTransactionModel.fromJson(txData, transactionId);
      }
      return null;
    } catch (e) {
      log('Error mengambil transaksi porter: $e');
      return null;
    }
  }

  @override
  Future<List<String>> getPorterTransactionIds(String userId) async {
    try {
      log('[TransactionPorterRepo] Mengambil ID transaksi untuk: $userId');
      List<String> allTransactionIds = [];

      // 1. Coba ambil dari porterHistory berdasarkan userId
      final snapshot = await _database.ref().child('porterHistory/$userId').get();
      if (snapshot.exists && snapshot.value != null) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        allTransactionIds.addAll(data.keys.map((key) => key.toString()));
        log('[TransactionPorterRepo] Ditemukan ${allTransactionIds.length} transaksi dari porterHistory/$userId');
      } else {
        log('[TransactionPorterRepo] Tidak ada data di porterHistory/$userId');
      }

      // 2. Cari transaksi yang memiliki porterUserId yang cocok
      final transactionsSnapshot = await _database.ref().child('porterTransactions').get();
      if (transactionsSnapshot.exists && transactionsSnapshot.value != null) {
        final allTransactions = transactionsSnapshot.value as Map<dynamic, dynamic>;

        // Cari transaksi dengan porterUserId yang cocok
        for (var key in allTransactions.keys) {
          final value = allTransactions[key];
          if (value is Map && value.containsKey('porterUserId') && value['porterUserId'] == userId) {
            final id = key.toString();
            if (!allTransactionIds.contains(id)) {
              allTransactionIds.add(id);
            }
          }
        }

        log('[TransactionPorterRepo] Menambahkan transaksi berdasarkan porterUserId, total: ${allTransactionIds.length}');
      }

      return allTransactionIds;
    } catch (e) {
      log('[TransactionPorterRepo] Error mendapatkan ID transaksi: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> getPorterTransactionById(String transactionId) async {
    try {
      log('[TransactionPorterRepo] Mengambil data transaksi untuk ID: $transactionId');

      // Ambil langsung dari node porterTransactions/{transactionId}
      final snapshot = await _database.ref().child('porterTransactions/$transactionId').get();

      if (snapshot.exists && snapshot.value != null) {
        final result = Map<String, dynamic>.from(snapshot.value as Map);
        log('[TransactionPorterRepo] Data transaksi ditemukan untuk ID: $transactionId');
        return result;
      }

      log('[TransactionPorterRepo] Data transaksi TIDAK ditemukan untuk ID: $transactionId');

      // Jika tidak ditemukan di lokasi langsung, coba cari di semua transaksi
      final allTransactions = await _database.ref().child('porterTransactions').get();
      if (allTransactions.exists && allTransactions.value != null) {
        final Map<dynamic, dynamic> allData = allTransactions.value as Map<dynamic, dynamic>;

        // Transactionid mungkin tersimpan sebagai child dari porter ID lain
        for (var key in allData.keys) {
          if (key.toString() == transactionId) {
            final result = Map<String, dynamic>.from(allData[key] as Map);
            log('[TransactionPorterRepo] Data transaksi ditemukan di level atas');
            return result;
          }
        }
      }

      return null;
    } catch (e) {
      log('[TransactionPorterRepo] Error mengambil data transaksi porter: $e');
      return null;
    }
  }

  @override
  Future<void> updateTransactionStatus({
    required String transactionId,
    required String status,
  }) async {
    try {
      final now = DateTime.now();

      // Update di Firestore
      await _firestore.collection('porterTransactions').doc(transactionId).update({
        'status': status,
        'updatedAt': now,
      });

      // Update di Realtime DB
      await _database.ref().child('porterTransactions/$transactionId').update({
        'status': status,
        'updatedAt': now.millisecondsSinceEpoch,
      });

      log('Berhasil memperbarui status transaksi: $transactionId menjadi $status');
    } catch (e) {
      log('Error memperbarui status transaksi: $e');
      throw Exception('Gagal memperbarui status transaksi: $e');
    }
  }

  @override
  Future<void> completePorterTransaction({
    required String transactionId,
    required String porterOnlineId,
  }) async {
    try {
      final now = DateTime.now();

      // Update status transaksi
      await updateTransactionStatus(
        transactionId: transactionId,
        status: 'selesai',
      );

      // Reset status porter
      await _firestore.collection('porterOnline').doc(porterOnlineId).update({
        'idTransaction': null,
        'idUser': null,
        'isAvailable': true,
        'onlineAt': now,
      });

      log('Transaksi porter berhasil diselesaikan');
    } catch (e) {
      log('Error menyelesaikan transaksi porter: $e');
      throw Exception('Gagal menyelesaikan transaksi porter: $e');
    }
  }

  // @override
  // Future<void> updateTransactionStatus({
  //   required String ticketId,
  //   required String transactionId,
  //   required String status,
  // }) async {
  //   try {
  //     final now = DateTime.now();
  //     log('Updating transaction status: $transactionId to $status');

  //     // Update di Firestore, coba dengan transactionId langsung
  //     try {
  //       await _firestore.collection('porterTransactions').doc(transactionId).update({
  //         'status': status,
  //         'updatedAt': now,
  //       });
  //       log('Successfully updated transaction in Firestore with direct ID');
  //     } catch (e) {
  //       log('Failed to update Firestore with direct ID: $e');

  //       // Coba dengan format ticketId-transactionId jika direct ID gagal
  //       if (ticketId.isNotEmpty) {
  //         final combinedId = '$ticketId-$transactionId';
  //         log('Trying update with combined ID: $combinedId');

  //         try {
  //           await _firestore.collection('porterTransactions').doc(combinedId).update({
  //             'status': status,
  //             'updatedAt': now,
  //           });
  //           log('Successfully updated transaction in Firestore with combined ID');
  //         } catch (e2) {
  //           log('Failed to update Firestore with combined ID: $e2');
  //         }
  //       }
  //     }

  //     // Mencari transaksi di Realtime DB
  //     // Perlu memeriksa semua porter untuk menemukan transaksi yang tepat
  //     final dbRef = _database.ref().child('porterTransactions');
  //     final dataSnapshot = await dbRef.get();

  //     if (dataSnapshot.exists && dataSnapshot.value is Map) {
  //       final allData = dataSnapshot.value as Map<dynamic, dynamic>;

  //       // Iterasi semua porter IDs
  //       for (var porterId in allData.keys) {
  //         final porterData = allData[porterId];

  //         if (porterData is Map<dynamic, dynamic> && porterData.containsKey(transactionId)) {
  //           log('Found transaction in Realtime DB under porter: $porterId');

  //           // Update status di Realtime DB
  //           final transactionRef =
  //               _database.ref().child('porterTransactions').child(porterId.toString()).child(transactionId);

  //           await transactionRef.update({
  //             'status': status,
  //             'updatedAt': now.millisecondsSinceEpoch,
  //           });

  //           log('Successfully updated transaction status in Realtime DB');
  //           break;
  //         }
  //       }
  //     }

  //     log('Status update process completed for transaction: $transactionId');
  //   } catch (e) {
  //     log('Error updating transaction status: $e');
  //     throw Exception('Failed to update transaction status: $e');
  //   }
  // }

  // @override
  // Future<void> completePorterTransaction({
  //   required String ticketId,
  //   required String transactionId,
  //   required String porterOnlineId,
  // }) async {
  //   try {
  //     final now = DateTime.now();
  //     log('Completing porter transaction: $transactionId and updating porterOnline: $porterOnlineId');

  //     await updateTransactionStatus(
  //       ticketId: ticketId,
  //       transactionId: transactionId,
  //       status: 'selesai',
  //     );

  //     try {
  //       await _firestore.collection('porterOnline').doc(porterOnlineId).update({
  //         'idTransaction': null,
  //         'idUser': null,
  //         'isAvailable': true,
  //         'onlineAt': now,
  //       });
  //       log('Successfully updated porterOnline data in Firestore');
  //     } catch (e) {
  //       log('Error updating porterOnline data in Firestore: $e');
  //       throw Exception('Gagal mengupdate data porterOnline di Firestore: $e');
  //     }

  //     // try {
  //     //   final porterOnlineRef = _database.ref().child('porterOnline').child(porterOnlineId);
  //     //   await porterOnlineRef.update({
  //     //     'idTransaction': null,
  //     //     'idUser': null,
  //     //     'isAvailable': true,
  //     //     'onlineAt': now.millisecondsSinceEpoch,
  //     //   });
  //     //   log('Successfully updated porterOnline data in Realtime DB');
  //     // } catch (e) {
  //     //   log('Error updating porterOnline data in Realtime DB: $e');
  //     // }

  //     log('Porter transaction completion process finished successfully');
  //   } catch (e) {
  //     log('Error completing porter transaction: $e');
  //     throw Exception('Gagal menyelesaikan transaksi porter: $e');
  //   }
  // }
}

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
        // Safe cast: Konversi Map<Object?, Object?> ke Map<String, dynamic>
        final Map<dynamic, dynamic> rawData = snapshot.value as Map;
        final Map<String, dynamic> result = {};

        // Proses setiap entry untuk memastikan keys sebagai string
        rawData.forEach((key, value) {
          String keyStr = key.toString();

          // Perlakukan rejectionInfo secara khusus
          if (keyStr == 'rejectionInfo' && value is Map) {
            Map<String, dynamic> rejectionMap = {};
            (value as Map).forEach((rKey, rValue) {
              rejectionMap[rKey.toString()] = rValue;
            });
            result[keyStr] = rejectionMap;
          } else {
            result[keyStr] = value;
          }
        });

        log('[TransactionPorterRepo] Data transaksi ditemukan untuk ID: $transactionId');
        return result;
      }

      log('[TransactionPorterRepo] Data transaksi TIDAK ditemukan untuk ID: $transactionId');
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
  Future<void> rejectTransaction({
    required String transactionId,
    required String reason,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    try {
      log('[TransactionPorterRepo] Menolak transaksi: $transactionId dengan alasan: $reason');

      // 1. Dapatkan data transaksi sekali dan simpan dalam variabel
      final transactionData = await getPorterTransactionById(transactionId);
      if (transactionData == null) {
        throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'Transaksi tidak ditemukan');
      }

      final String porterOnlineId = transactionData['porterOnlineId'] ?? '';
      if (porterOnlineId.isEmpty) {
        throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'ID Porter tidak ditemukan pada transaksi');
      }

      final rejectionId = DateTime.now().millisecondsSinceEpoch.toString();

      // Data yang akan digunakan untuk menyimpan di kedua tempat (Realtime Database & Firestore)
      final rejectionData = {
        'idPassenger': transactionData['idPassenger'] ?? '',
        'kodePorter': transactionData['kodePorter'] ?? '',
        'locationPassenger': transactionData['locationPassenger'] ?? '',
        'locationPoter': transactionData['locationPorter'] ?? '',
        'porterId': porterOnlineId,
        'porterUserId': transactionData['porterUserId'] ?? '',
        'ticketId': transactionData['ticketId'] ?? '',
        'transactionId': transactionData['transactionId'] ?? '',
        'status': 'rejected',
        'reason': reason,
        'timestamp': now
      };

      // 2. Mulai Batch untuk mengelola multiple writes dengan lebih efisien di Firestore
      final WriteBatch batch = _firestore.batch();
      final transactionRef = _firestore.collection('porterTransactions').doc(transactionId);
      final rejectionRef = _firestore.collection('porterRejections').doc(rejectionId);

      // 3. Menyimpan riwayat penolakan di Firestore menggunakan Batch
      batch.set(rejectionRef, rejectionData);

      // 4. Update transaksi untuk tampilan di tab "Ditolak"
      batch.update(transactionRef, {
        'updatedAt': now,
        'locationPorter': null,
        'porterOnlineId': null,
        'porterUserId': null,
        'status': 'rejected',
        'rejectionInfo': {'reason': reason, 'timestamp': now, 'status': 'rejected'},
      });

      await _database.ref().child('porterTransactions/$transactionId').update({
        'updatedAt': now,
        'locationPorter': null,
        'porterOnlineId': null,
        'porterUserId': null,
        'status': 'rejected',
        'rejectionInfo': {'reason': reason, 'timestamp': now, 'status': 'rejected'},
      });

      log('[Repository_impl] ID Transaction Porter: $transactionId');

      // 5. Reset status porter supaya tersedia kembali
      final porterRef = _firestore.collection('porterOnline').doc(porterOnlineId);
      batch.update(porterRef, {
        'idTransaction': null,
        'idUser': null,
        'isAvailable': true,
      });

      // 6. Commit batch ke Firestore
      await batch.commit();

      log('[TransactionPorterRepo] Transaksi berhasil ditolak dan dikembalikan ke antrian di Firestore');

      // 7. Simpan juga ke Realtime Database untuk pencatatan sementara
      await _database.ref().child('porterRejections/$rejectionId').set(rejectionData);

      log('[TransactionPorterRepo] Data penolakan berhasil disimpan di Realtime Database');
    } catch (e) {
      log('[TransactionPorterRepo] Error menolak transaksi: ${e.toString()}', level: 4);
      throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'Gagal menolak transaksi: ${e.toString()}');
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

  @override
Future<String?> reassignRejectedTransaction({
  required String transactionId,
  String? newPorterId,
}) async {
  try {
    log('[TransactionPorterRepo] Mencoba mengalihkan transaksi: $transactionId');

    // 1. Dapatkan data transaksi yang ditolak
    final rejectedTransaction = await getPorterTransactionById(transactionId);
    if (rejectedTransaction == null) {
      throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'Transaksi tidak ditemukan');
    }

    // Verifikasi bahwa transaksi ini memang ditolak
    final status = rejectedTransaction['status'] as String? ?? '';
    final hasRejectionInfo = rejectedTransaction.containsKey('rejectionInfo');
    
    if (status != 'rejected' && !hasRejectionInfo) {
      throw FirebaseException(
        plugin: 'TransactionPorterRepo', 
        message: 'Transaksi tidak dalam status ditolak'
      );
    }

    // 2. Tandai transaksi lama sebagai sudah dialihkan
    await _database.ref().child('porterTransactions/$transactionId').update({
      'isReassigned': true,
    });

    // 3. Cari porter yang tersedia (jika tidak ada yang ditentukan)
    String selectedPorterId = '';
    String porterUserId = '';
    String porterLocation = '';
    
    if (newPorterId != null && newPorterId.isNotEmpty) {
      // Gunakan porter yang ditentukan
      final porterDoc = await _firestore.collection('porterOnline').doc(newPorterId).get();
      
      if (!porterDoc.exists) {
        throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'Porter yang ditentukan tidak ditemukan');
      }
      
      final porterData = porterDoc.data();
      if (porterData == null || porterData['isAvailable'] != true) {
        throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'Porter yang ditentukan tidak tersedia');
      }
      
      selectedPorterId = newPorterId;
      porterUserId = porterData['userId'] ?? '';
      porterLocation = porterData['location'] ?? '';
    } else {
      // Cari porter yang tersedia
      final availablePortersSnapshot = await _firestore
          .collection('porterOnline')
          .where('isAvailable', isEqualTo: true)
          .limit(1)
          .get();
      
      if (availablePortersSnapshot.docs.isEmpty) {
        throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'Tidak ada porter tersedia saat ini');
      }
      
      final porterDoc = availablePortersSnapshot.docs.first;
      final porterData = porterDoc.data();
      
      selectedPorterId = porterDoc.id;
      porterUserId = porterData['userId'] ?? '';
      porterLocation = porterData['location'] ?? '';
    }
    
    log('[TransactionPorterRepo] Porter baru dipilih: $selectedPorterId (userId: $porterUserId)');

    // 4. Buat transaksi baru dengan referensi ke transaksi lama
    final now = DateTime.now().millisecondsSinceEpoch;
    final newTransactionId = '${now}_${100000 + (now % 900000)}';
    
    // Data untuk transaksi baru
    final newTransactionData = <String, dynamic>{
      'transactionId': rejectedTransaction['transactionId'] ?? '',
      'ticketId': rejectedTransaction['ticketId'] ?? '',
      'idPassenger': rejectedTransaction['idPassenger'] ?? '',
      'locationPassenger': rejectedTransaction['locationPassenger'] ?? '',
      'kodePorter': rejectedTransaction['kodePorter'] ?? '',
      'status': 'pending',
      'createdAt': now,
      'porterOnlineId': selectedPorterId,
      'porterUserId': porterUserId,
      'locationPorter': porterLocation,
      'previousTransactionId': transactionId, // Referensi ke transaksi yang ditolak
    };
    
    // Jika ada rejectionInfo, tambahkan alasan pengalihan
    if (hasRejectionInfo && rejectedTransaction['rejectionInfo'] is Map) {
      final rejectionInfoMap = rejectedTransaction['rejectionInfo'] as Map<dynamic, dynamic>;
      final reason = rejectionInfoMap['reason']?.toString() ?? 'Ditolak oleh porter sebelumnya';
      
      newTransactionData['reassignmentInfo'] = {
        'previousTransactionId': transactionId,
        'reason': reason,
        'timestamp': now,
      };
    }

    // 5. Simpan transaksi baru ke Realtime Database dan Firestore
    final batch = _firestore.batch();
    
    // Ke Realtime Database
    await _database.ref().child('porterTransactions/$newTransactionId').set(newTransactionData);
    
    // Firestore - update porter
    final porterRef = _firestore.collection('porterOnline').doc(selectedPorterId);
    batch.update(porterRef, {
      'isAvailable': false,
      'idTransaction': newTransactionId,
      'idUser': rejectedTransaction['idPassenger'] ?? '',
    });
    
    // Commit Firestore batch
    await batch.commit();

    // 6. Tambahkan ke porterHistory
    if (porterUserId.isNotEmpty) {
      await _database.ref().child('porterHistory/$porterUserId/$newTransactionId').set({
        'timestamp': now,
        'transactionId': newTransactionId,
      });
    }
    
    // Tambahkan ke history porterId juga
    if (selectedPorterId.isNotEmpty) {
      await _database.ref().child('porterHistory/$selectedPorterId/$newTransactionId').set({
        'timestamp': now,
        'transactionId': newTransactionId,
      });
    }

    // 7. Tambahkan ke passengerHistory
    final passengerId = rejectedTransaction['idPassenger'] ?? '';
    if (passengerId.isNotEmpty) {
      await _database.ref().child('passengerHistory/$passengerId/$newTransactionId').set({
        'timestamp': now,
        'transactionId': newTransactionId,
      });
    }

    log('[TransactionPorterRepo] Transaksi berhasil dialihkan ke porter baru. ID baru: $newTransactionId');
    return newTransactionId;
  } catch (e) {
    log('[TransactionPorterRepo] Error mengalihkan transaksi: $e', level: 4);
    throw FirebaseException(plugin: 'TransactionPorterRepo', message: 'Gagal mengalihkan transaksi: $e');
  }
}
}

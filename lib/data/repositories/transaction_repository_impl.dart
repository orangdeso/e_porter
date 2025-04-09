import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_porter/domain/models/transaction_model.dart';
import 'package:e_porter/domain/repositories/transaction_repository.dart';
import 'package:path/path.dart' as path;

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  TransactionRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  // Method untuk generate ID unik
  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        '_' +
        (100000 + (DateTime.now().microsecond % 900000)).toString();
  }

  @override
  Future<String> createTransaction({
    required String ticketId,
    required String flightId,
    required double amount,
    required String method,
    required DateTime expiryTime,
    required Map<String, dynamic> flightDetails,
    required Map<String, dynamic> bandaraDetails,
    Map<String, dynamic>? porterServiceDetails,
    required Map<String, dynamic> userDetails,
    required int passenger,
    required List<Map<String, dynamic>> passengerDetails,
    required List<String> numberSeat,
  }) async {
    try {
      final transactionId = _generateUniqueId();
      final now = DateTime.now();

      final transactionData = {
        'id': transactionId,
        'ticketId': ticketId,
        'flightId': flightId,
        'amount': amount,
        'method': method,
        'status': 'pending',
        'createdAt': now,
        'expiryTime': expiryTime,
        'flightDetails': flightDetails,
        'bandaraDetails': bandaraDetails,
        'porterServiceDetails': porterServiceDetails,
        'userDetails': userDetails,
        'passenger': passenger,
        'passengerDetails': passengerDetails,
        'numberSeat': numberSeat,
      };

      await _firestore
          .collection('tickets')
          .doc(ticketId)
          .collection('payments')
          .doc(transactionId)
          .set(transactionData);

      DocumentSnapshot seatData =
          await _firestore.collection('tickets').doc(ticketId).collection('flights').doc(flightId).get();

      if (seatData.exists) {
        Map<String, dynamic>? data = seatData.data() as Map<String, dynamic>?;
        String getSeatClass(String seatNumber) {
          if (seatNumber.isNotEmpty) {
            return seatNumber[0].toLowerCase();
          }
          return "a";
        }

        int getSeatIndex(String seatNumber) {
          if (seatNumber.length > 1) {
            try {
              return int.parse(seatNumber.substring(1)) - 1;
            } catch (e) {
              log("Error parsing seat index: $e");
            }
          }
          return 0;
        }

        for (String seatNumber in numberSeat) {
          String seatClass = getSeatClass(seatNumber);
          int seatIndex = getSeatIndex(seatNumber);
          log("Processing seat: $seatNumber, class: $seatClass, index: $seatIndex");

          if (data != null && data.containsKey('seat')) {
            Map<String, dynamic> seatData = Map<String, dynamic>.from(data['seat']);

            if (seatData.containsKey(seatClass)) {
              Map<String, dynamic> classSeatData = Map<String, dynamic>.from(seatData[seatClass]);

              if (classSeatData.containsKey('isTaken')) {
                List<dynamic> isTaken = List<dynamic>.from(classSeatData['isTaken'] ?? []);

                while (isTaken.length <= seatIndex) {
                  isTaken.add(false);
                }
                isTaken[seatIndex] = true;

                await _firestore
                    .collection('tickets')
                    .doc(ticketId)
                    .collection('flights')
                    .doc(flightId)
                    .update({'seat.$seatClass.isTaken': isTaken});

                log("Successfully updated seat $seatNumber in class $seatClass at index $seatIndex");
              } else {
                List<dynamic> isTaken = List.filled(seatIndex + 1, false);
                isTaken[seatIndex] = true;

                await _firestore
                    .collection('tickets')
                    .doc(ticketId)
                    .collection('flights')
                    .doc(flightId)
                    .update({'seat.$seatClass.isTaken': isTaken});

                log("Created new isTaken array for seat $seatNumber in class $seatClass");
              }
            } else {
              List<dynamic> isTaken = List.filled(seatIndex + 1, false);
              isTaken[seatIndex] = true;

              await _firestore.collection('tickets').doc(ticketId).collection('flights').doc(flightId).update({
                'seat.$seatClass': {'isTaken': isTaken}
              });

              log("Created new seat class $seatClass for seat $seatNumber");
            }
          } else {
            List<dynamic> isTaken = List.filled(seatIndex + 1, false);
            isTaken[seatIndex] = true;

            Map<String, dynamic> newSeatData = {
              'seat': {
                seatClass: {'isTaken': isTaken}
              }
            };

            await _firestore
                .collection('tickets')
                .doc(ticketId)
                .collection('flights')
                .doc(flightId)
                .set(newSeatData, SetOptions(merge: true));

            log("Created complete new seat structure for seat $seatNumber");
          }
        }
      } else {
        log("Flight document not found");
        throw Exception("Flight document not found");
      }

      final databaseRef = FirebaseDatabase.instance.ref();
      final userId = userDetails['uid'];
      await databaseRef.child('transactions/$userId/$ticketId/$transactionId').set({
        'payment': {
          'id': transactionId,
          'status': 'pending',
          'amount': amount,
          'method': method,
          'createdAt': now.millisecondsSinceEpoch,
          'expiryTime': expiryTime.millisecondsSinceEpoch,
        },
        'flight': flightDetails,
        'bandara': bandaraDetails,
        'porterService': porterServiceDetails,
        'user': userDetails,
        'passenger': passenger,
        'passengerDetails': passengerDetails,
        'numberSeat': numberSeat,
      });

      return transactionId;
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  @override
  Future<void> updateTransactionStatus({
    required String ticketId,
    required String transactionId,
    required String status,
    required String userId,
  }) async {
    try {
      final now = DateTime.now();

      await _firestore.collection('tickets').doc(ticketId).collection('payments').doc(transactionId).update({
        'status': status,
        'updatedAt': now,
      });

      final databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('transactions/$userId/$ticketId/$transactionId/payment').update({
        'status': status,
        'updatedAt': now.millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to update transaction status: $e');
    }
  }

  @override
  Future<void> uploadPaymentProof({
    required String ticketId,
    required String transactionId,
    required File proofImage,
    required String userId,
  }) async {
    try {
      final fileName =
          'payment_proof_${transactionId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(proofImage.path)}';
      final storageRef = _storage.ref().child('payment/$fileName');

      // Tambahkan listener untuk progress upload
      final uploadTask = storageRef.putFile(proofImage);

      // Upload file ke Firebase Storage
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final now = DateTime.now();

      // Update Firestore
      await _firestore.collection('tickets').doc(ticketId).collection('payments').doc(transactionId).update({
        'proofUrl': downloadUrl,
        'status': 'active',
        'paidAt': now,
      });

      // Update Realtime Database
      final databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('transactions/$userId/$ticketId/$transactionId/payment').update({
        'proofUrl': downloadUrl,
        'status': 'active',
        'paidAt': now.millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to upload payment proof: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByUserId(String userId) async {
    try {
      final ticketQuerySnapshot = await _firestore.collection('tickets').where('userId', isEqualTo: userId).get();
      final List<TransactionModel> transactions = [];

      for (var ticketDoc in ticketQuerySnapshot.docs) {
        final ticketId = ticketDoc.id;
        final paymentsSnapshot = await _firestore.collection('tickets').doc(ticketId).collection('payments').get();

        for (var paymentDoc in paymentsSnapshot.docs) {
          final data = paymentDoc.data();
          data['id'] = paymentDoc.id;
          transactions.add(TransactionModel.fromJson(data));
        }
      }

      return transactions;
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  @override
  Future<TransactionModel?> getTransactionById({required String ticketId, required String transactionId}) async {
    try {
      final docSnapshot =
          await _firestore.collection('tickets').doc(ticketId).collection('payments').doc(transactionId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        data['id'] = docSnapshot.id;
        return TransactionModel.fromJson(data);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  @override
  Future<void> syncTransactionToRealtimeDB({required String ticketId, required String transactionId}) async {
    try {
      final transaction = await getTransactionById(ticketId: ticketId, transactionId: transactionId);

      if (transaction != null) {
        final databaseRef = FirebaseDatabase.instance.ref();
        await databaseRef.child('transactions/$ticketId').set({
          'payment': {
            'id': transaction.id,
            'status': transaction.status,
            'amount': transaction.amount,
            'method': transaction.method,
            'proofUrl': transaction.proofUrl,
            'createdAt': transaction.createdAt.millisecondsSinceEpoch,
            'expiryTime': transaction.expiryTime.millisecondsSinceEpoch,
          },
          'flight': transaction.flightDetails,
          'bandara': transaction.bandaraDetails,
          'porterService': transaction.porterServiceDetails,
          'user': transaction.userDetails,
          'passenger': transaction.passenger,
        });
      }
    } catch (e) {
      throw Exception('Failed to sync transaction to Realtime DB: $e');
    }
  }

  @override
  Stream<TransactionModel?> watchTransaction({required String ticketId, required String transactionId}) {
    return _firestore
        .collection('tickets')
        .doc(ticketId)
        .collection('payments')
        .doc(transactionId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        data['id'] = snapshot.id;
        return TransactionModel.fromJson(data);
      }
      return null;
    });
  }

  Future<void> checkAndCancelExpiredTransactions() async {
    try {
      log('[TransactionRepository] Mulai memeriksa transaksi kedaluwarsa');
      final now = DateTime.now();

      final ticketsCheck = await _firestore.collection('tickets').limit(1).get();
      if (ticketsCheck.docs.isEmpty) {
        log('[TransactionRepository] Tidak ada tiket untuk diperiksa, melewati pengecekan');
        return;
      }

      try {
        final pendingTransactionsSnapshot = await _firestore
            .collectionGroup('payments')
            .where('status', isEqualTo: 'pending')
            .orderBy('createdAt', descending: false)
            .get();

        for (var doc in pendingTransactionsSnapshot.docs) {
          final data = doc.data();
          final expiryTime = (data['expiryTime'] as Timestamp).toDate();

          // Jika sudah melewati waktu pembayaran
          if (expiryTime.isBefore(now)) {
            final ticketId = data['ticketId'];
            final transactionId = doc.id;
            final userId = data['userDetails']['uid'];
            final flightId = data['flightId'];
            final numberSeat = (data['numberSeat'] as List).map((e) => e.toString()).toList();

            // Update status di Firestore
            await _firestore.collection('tickets').doc(ticketId).collection('payments').doc(transactionId).update({
              'status': 'cancelled',
              'updatedAt': now,
            });

            // Reset status kursi
            await _resetSeatStatus(ticketId, flightId, numberSeat);

            // Update status di Realtime Database
            final databaseRef = FirebaseDatabase.instance.ref();
            await databaseRef.child('transactions/$userId/$ticketId/$transactionId/payment').update({
              'status': 'cancelled',
              'updatedAt': now.millisecondsSinceEpoch,
            });

            log('Transaksi $transactionId dibatalkan karena kedaluwarsa');
          }
        }
      } catch (e) {
        if (e.toString().contains('failed-precondition') || e.toString().contains('requires an index')) {
          log('[TransactionRepository] Indeks belum tersedia. Menggunakan metode alternatif.');
          // Gunakan metode alternatif yang tidak memerlukan indeks khusus
          await checkAndCancelExpiredTransactionsAlternative();
        } else {
          rethrow;
        }
      }
    } catch (e) {
      log('[TransactionRepository] Error memeriksa transaksi kedaluwarsa: $e');
      rethrow;
    }
  }

  // Metode helper untuk mereset status kursi
  Future<void> _resetSeatStatus(String ticketId, String flightId, List<String> numberSeat) async {
    try {
      DocumentSnapshot seatData =
          await _firestore.collection('tickets').doc(ticketId).collection('flights').doc(flightId).get();

      if (seatData.exists) {
        Map<String, dynamic>? data = seatData.data() as Map<String, dynamic>?;

        for (String seatNumber in numberSeat) {
          String seatClass = getSeatClass(seatNumber);
          int seatIndex = getSeatIndex(seatNumber);

          if (data != null && data.containsKey('seat')) {
            Map<String, dynamic> seatData = Map<String, dynamic>.from(data['seat']);

            if (seatData.containsKey(seatClass)) {
              Map<String, dynamic> classSeatData = Map<String, dynamic>.from(seatData[seatClass]);

              if (classSeatData.containsKey('isTaken')) {
                List<dynamic> isTaken = List<dynamic>.from(classSeatData['isTaken'] ?? []);

                if (seatIndex < isTaken.length) {
                  isTaken[seatIndex] = false; // Reset status kursi

                  await _firestore
                      .collection('tickets')
                      .doc(ticketId)
                      .collection('flights')
                      .doc(flightId)
                      .update({'seat.$seatClass.isTaken': isTaken});

                  log("Reset kursi $seatNumber di kelas $seatClass pada indeks $seatIndex");
                }
              }
            }
          }
        }
      }
    } catch (e) {
      log("Error mereset status kursi: $e");
    }
  }

  String getSeatClass(String seatNumber) {
    if (seatNumber.isNotEmpty) {
      return seatNumber[0].toLowerCase();
    }
    return "a";
  }

  int getSeatIndex(String seatNumber) {
    if (seatNumber.length > 1) {
      try {
        return int.parse(seatNumber.substring(1)) - 1;
      } catch (e) {
        log("Error parsing seat index: $e");
      }
    }
    return 0;
  }

  Future<void> checkAndCancelExpiredTransactionsAlternative() async {
    try {
      final now = DateTime.now();
      log('[TransactionRepository] Menggunakan metode alternatif untuk memeriksa transaksi');

      final ticketsSnapshot = await _firestore.collection('tickets').get();

      int count = 0;
      for (var ticketDoc in ticketsSnapshot.docs) {
        final ticketId = ticketDoc.id;

        final paymentsSnapshot = await _firestore
            .collection('tickets')
            .doc(ticketId)
            .collection('payments')
            .where('status', isEqualTo: 'pending')
            .get();

        for (var doc in paymentsSnapshot.docs) {
          final data = doc.data();
          if (data.containsKey('expiryTime')) {
            final expiryTime = (data['expiryTime'] as Timestamp).toDate();

            if (expiryTime.isBefore(now)) {
              final transactionId = doc.id;
              final userId = data['userDetails']?['uid'];
              final flightId = data['flightId'];
              final List<String> numberSeat = [];

              if (data.containsKey('numberSeat')) {
                numberSeat.addAll((data['numberSeat'] as List).map((e) => e.toString()));
              }

              log('[TransactionRepository] Memproses transaksi kedaluwarsa alternatif: $transactionId');

              // Update status transaksi
              await _firestore.collection('tickets').doc(ticketId).collection('payments').doc(transactionId).update({
                'status': 'cancelled',
                'updatedAt': now,
              });

              // Reset seat status
              if (numberSeat.isNotEmpty) {
                await _resetSeatStatus(ticketId, flightId, numberSeat);
              }

              // Update Realtime Database jika userId tersedia
              if (userId != null) {
                final databaseRef = FirebaseDatabase.instance.ref();
                await databaseRef.child('transactions/$userId/$ticketId/$transactionId/payment').update({
                  'status': 'cancelled',
                  'updatedAt': now.millisecondsSinceEpoch,
                });
              }

              count++;
            }
          }
        }
      }

      log('[TransactionRepository] Selesai memeriksa transaksi (metode alternatif), $count transaksi dibatalkan');
    } catch (e) {
      log('[TransactionRepository] Error pada metode alternatif: $e');
    }
  }
}

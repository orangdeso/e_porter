import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<TransactionModel>> getTransactionsStream(String userId, String status) {
    final ref = _database.ref().child('transactions').child(userId);

    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      // log('HistoryRepositoryImpl: snapshot diterima, exists: ${snapshot.exists}, has children: ${snapshot.children.isNotEmpty}');

      if (!snapshot.exists || snapshot.value == null) {
        // log('HistoryRepositoryImpl: tidak ada data transaksi untuk userId: $userId');
        return <TransactionModel>[];
      }

      try {
        final Map<dynamic, dynamic> userTransactions = snapshot.value as Map<dynamic, dynamic>;
        // log('HistoryRepositoryImpl: jumlah grup transaksi: ${userTransactions.length}');

        List<TransactionModel> transactions = [];

        userTransactions.forEach((groupKey, groupData) {
          if (groupData is Map<dynamic, dynamic>) {
            groupData.forEach((transactionKey, transactionData) {
              try {
                if (transactionData is Map<dynamic, dynamic>) {
                  if (transactionData.containsKey('payment') &&
                      transactionData['payment'] is Map &&
                      transactionData['payment'].containsKey('status')) {
                    final paymentStatus = transactionData['payment']['status'];

                    if (paymentStatus == status) {
                      final payment = transactionData['payment'] as Map<dynamic, dynamic>;
                      final Map<String, dynamic> processedData = {
                        'id': payment['id'] ?? transactionKey,
                        'idBooking': transactionData['idBooking'] ?? '',
                        'ticketId': groupKey,
                        'flightId': transactionData['flight']?['code'] ?? '',

                        // Data payment
                        'amount': payment['amount'] ?? 0.0,
                        'method': payment['method'] ?? '',
                        'status': paymentStatus,
                        'proofUrl': payment['proofUrl'],
                        'createdAt': payment['createdAt'] != null
                            ? DateTime.fromMillisecondsSinceEpoch(payment['createdAt'] as int)
                            : DateTime.now(),
                        'expiryTime': payment['expiryTime'] != null
                            ? DateTime.fromMillisecondsSinceEpoch(payment['expiryTime'] as int)
                            : DateTime.now().add(Duration(hours: 1)),

                        'flightDetails': Map<String, dynamic>.from(transactionData['flight'] ?? {}),
                        'bandaraDetails': Map<String, dynamic>.from(transactionData['bandara'] ?? {}),
                        'porterServiceDetails': transactionData['porterService'] != null
                            ? Map<String, dynamic>.from(transactionData['porterService'])
                            : null,
                        'userDetails': Map<String, dynamic>.from(transactionData['user'] ?? {}),

                        // Data tambahan
                        'passenger': transactionData['passenger'] ?? 0,
                        'passengerDetails': transactionData['passengerDetails'] ?? [],
                        'numberSeat': transactionData['numberSeat'] ?? [],
                      };

                      final transaction = TransactionModel.fromJson(processedData);
                      transactions.add(transaction);

                      // log('HistoryRepositoryImpl: transaksi dengan id: $transactionKey ditambahkan ke daftar (status: $status)');
                    }
                  }
                }
              } catch (e) {
                log('HistoryRepositoryImpl: error parsing transaksi dengan id: $transactionKey, error: $e');
              }
            });
          }
        });

        log('HistoryRepositoryImpl: jumlah transaksi dengan status $status: ${transactions.length}');
        return transactions;
      } catch (e) {
        log('HistoryRepositoryImpl: error saat memproses snapshot: $e');
        return <TransactionModel>[];
      }
    });
  }

  @override
  Stream<List<TransactionModel>> getHistoryTransactionsStream(String userId) {
    return getTransactionsStream(userId, 'active').map((allPaid) {
      final startOfToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      return allPaid.where((tx) => tx.departureDate.isBefore(startOfToday)).toList();
    });
  }

  @override
  Future<TransactionModel?> getTransactionFromFirestore(String ticketId, String transactionId) async {
    try {
      log('HistoryRepositoryImpl: mengambil transaksi dari Firestore dengan ticketId: $ticketId, transactionId: $transactionId');

      // Referensi ke dokumen transaksi di Firestore
      final docRef = _firestore.collection('tickets').doc(ticketId).collection('payments').doc(transactionId);

      // Mengambil data dokumen
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        log('HistoryRepositoryImpl: transaksi tidak ditemukan di Firestore');
        return null;
      }

      // Mengambil data dari dokumen
      final data = docSnapshot.data();
      if (data == null) {
        log('HistoryRepositoryImpl: data transaksi kosong');
        return null;
      }

      // Pastikan id dokumen tersimpan dalam data
      data['id'] = transactionId;
      data['ticketId'] = ticketId;

      final transaction = TransactionModel.fromJson(data);
      log('HistoryRepositoryImpl: berhasil mengambil transaksi dari Firestore');
      return transaction;
    } catch (e) {
      log('HistoryRepositoryImpl: error saat mengambil transaksi dari Firestore: $e');
      return null;
    }
  }
  
  @override
  Future<bool> checkIfTicketHasPorter(String ticketId, String transactionId) async {
    try {
      log('HistoryRepositoryImpl: checking if ticket has porter, ticketId: $ticketId, transactionId: $transactionId');
      
      final querySnapshot = await _firestore
          .collection('porterTransactions')
          .where('ticketId', isEqualTo: ticketId)
          .where('transactionId', isEqualTo: transactionId)
          .limit(1)
          .get();
      
      final hasPorter = querySnapshot.docs.isNotEmpty;
      log('HistoryRepositoryImpl: ticket has porter: $hasPorter');
      
      return hasPorter;
    } catch (e) {
      log('HistoryRepositoryImpl: error checking if ticket has porter: $e');
      return false;
    }
  }
  
  @override
  Future<String?> getPorterTransactionId(String ticketId, String transactionId) async {
    try {
      log('HistoryRepositoryImpl: getting porter transaction ID, ticketId: $ticketId, transactionId: $transactionId');
      
      final querySnapshot = await _firestore
          .collection('porterTransactions')
          .where('ticketId', isEqualTo: ticketId)
          .where('transactionId', isEqualTo: transactionId)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        log('HistoryRepositoryImpl: no porter transaction found');
        return null;
      }
      
      final porterTransactionId = querySnapshot.docs.first.id;
      log('HistoryRepositoryImpl: found porter transaction ID: $porterTransactionId');
      
      return porterTransactionId;
    } catch (e) {
      log('HistoryRepositoryImpl: error getting porter transaction ID: $e');
      return null;
    }
  }
}

import 'dart:io';
import 'package:e_porter/domain/models/transaction_model.dart';

abstract class TransactionRepository {
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
  });

  Future<void> updateTransactionStatus({
    required String ticketId,
    required String transactionId,
    required String status,
    required String userId,
  });

  Future<void> uploadPaymentProof({
    required String ticketId,
    required String transactionId,
    required File proofImage,
  });

  Future<List<TransactionModel>> getTransactionsByUserId(String userId);

  Future<TransactionModel?> getTransactionById({required String ticketId, required String transactionId});

  Future<void> syncTransactionToRealtimeDB({required String ticketId, required String transactionId});

  Stream<TransactionModel?> watchTransaction({required String ticketId, required String transactionId});
}

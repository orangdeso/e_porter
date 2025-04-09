import 'dart:io';
import 'package:e_porter/domain/models/transaction_model.dart';
import 'package:e_porter/domain/repositories/transaction_repository.dart';

class TransactionUseCase {
  final TransactionRepository _repository;

  TransactionUseCase(this._repository);

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
    required List<Map<String, dynamic>> passengerDetails, // Tambah parameter ini
    required List<String> numberSeat, // Tambah parameter ini
  }) {
    return _repository.createTransaction(
      ticketId: ticketId,
      flightId: flightId,
      amount: amount,
      method: method,
      expiryTime: expiryTime,
      flightDetails: flightDetails,
      bandaraDetails: bandaraDetails,
      porterServiceDetails: porterServiceDetails,
      userDetails: userDetails,
      passenger: passenger,
      passengerDetails: passengerDetails, // Tambahkan parameter ini
      numberSeat: numberSeat, // Tambahkan parameter ini
    );
  }

  Future<void> updateTransactionStatus({
    required String ticketId,
    required String transactionId,
    required String status,
    required String userId,
  }) {
    return _repository.updateTransactionStatus(
      ticketId: ticketId,
      transactionId: transactionId,
      status: status,
      userId: userId,
    );
  }

  Future<void> uploadPaymentProof({
    required String ticketId,
    required String transactionId,
    required File proofImage,
    required String userId,
  }) {
    return _repository.uploadPaymentProof(
      ticketId: ticketId,
      transactionId: transactionId,
      proofImage: proofImage,
      userId: userId,
    );
  }

  Future<List<TransactionModel>> getTransactionsByUserId(String userId) {
    return _repository.getTransactionsByUserId(userId);
  }

  Future<TransactionModel?> getTransactionById({required String ticketId, required String transactionId}) {
    return _repository.getTransactionById(ticketId: ticketId, transactionId: transactionId);
  }

  Future<void> syncTransactionToRealtimeDB({required String ticketId, required String transactionId}) {
    return _repository.syncTransactionToRealtimeDB(ticketId: ticketId, transactionId: transactionId);
  }

  Stream<TransactionModel?> watchTransaction({required String ticketId, required String transactionId}) {
    return _repository.watchTransaction(ticketId: ticketId, transactionId: transactionId);
  }
}

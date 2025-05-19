import '../models/transaction_model.dart';

abstract class HistoryRepository {
  Stream<List<TransactionModel>> getTransactionsStream(String userId, String status);
  Stream<List<TransactionModel>> getHistoryTransactionsStream(String userId);
  Future<TransactionModel?> getTransactionFromFirestore(String ticketId, String transactionId);
  Future<bool> checkIfTicketHasPorter(String ticketId, String transactionId);
  Future<String?> getPorterTransactionId(String ticketId, String transactionId);
}

import '../models/transaction_model.dart';

abstract class HistoryRepository {
  Stream<List<TransactionModel>> getTransactionsStream(String userId, String status);
  Stream<List<TransactionModel>> getHistoryTransactionsStream(String userId);
  Future<TransactionModel?> getTransactionFromFirestore(String ticketId, String transactionId);
}

import '../models/transaction_porter_model.dart';

abstract class TransactionPorterRepository {
  Stream<List<PorterTransactionModel>> watchPorterTransactions(String porterId);

  Stream<PorterTransactionModel?> watchTransactionById(String transactionId);

  Future<Map<String, dynamic>?> getPorterTransactionById(String transactionId);

  Future<PorterTransactionModel?> getTransactionById(String transactionId);

  Future<List<String>> getPorterTransactionIds(String porterId);

  Future<void> updateTransactionStatus({
    required String transactionId,
    required String status,
  });

  Future<void> rejectTransaction({
    required String transactionId,
    required String reason,
  });

  Future<void> completePorterTransaction({
    required String transactionId,
    required String porterOnlineId,
  });

  Future<String?> reassignRejectedTransaction({
    required String transactionId,
    String? newPorterId,
  });
}

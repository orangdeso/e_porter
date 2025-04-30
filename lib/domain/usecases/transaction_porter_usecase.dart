import '../models/transaction_porter_model.dart';
import '../repositories/transaction_porter_repository.dart';

class TransactionPorterUsecase {
  final TransactionPorterRepository _repository;
  TransactionPorterUsecase(this._repository);

  Stream<List<PorterTransactionModel>> watchPorterTransactions(String porterId) {
    return _repository.watchPorterTransactions(porterId);
  }

  Stream<PorterTransactionModel?> watchTransactionById(String transactionId) {
    return _repository.watchTransactionById(transactionId);
  }

  Future<Map<String, dynamic>?> getPorterTransactionById(String transactionId) {
    return _repository.getPorterTransactionById(transactionId);
  }

  Future<PorterTransactionModel?> getTransactionById(String transactionId) {
    return _repository.getTransactionById(transactionId);
  }

  Future<List<String>> getPorterTransactionIds(String porterId) {
    return _repository.getPorterTransactionIds(porterId);
  }

  Future<void> updateTransactionStatus({
    required String transactionId,
    required String status,
  }) {
    return _repository.updateTransactionStatus(
      transactionId: transactionId,
      status: status,
    );
  }

  Future<void> rejectTransaction({
    required String transactionId,
    required String reason,
  }) {
    return _repository.rejectTransaction(
      transactionId: transactionId,
      reason: reason,
    );
  }

  Future<void> completePorterTransaction({
    required String transactionId,
    required String porterOnlineId,
  }) {
    return _repository.completePorterTransaction(
      transactionId: transactionId,
      porterOnlineId: porterOnlineId,
    );
  }

  Future<String?> reassignRejectedTransaction({
    required String transactionId,
    String? newPorterId,
  }) {
    return _repository.reassignRejectedTransaction(
      transactionId: transactionId,
      newPorterId: newPorterId,
    );
  }
}

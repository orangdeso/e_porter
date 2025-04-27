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

  Future<PorterTransactionModel?> getTransactionById(String transactionId) {
    return _repository.getTransactionById(transactionId);
  }

  Future<List<String>> getPorterTransactionIds(String porterId) {
    return _repository.getPorterTransactionIds(porterId);
  }

  Future<Map<String, dynamic>?> getPorterTransactionById(String transactionId) {
    return _repository.getPorterTransactionById(transactionId);
  }

  Future<void> updateTransactionStatus({
    // required String ticketId,
    required String transactionId,
    required String status,
  }) {
    return _repository.updateTransactionStatus(
      // ticketId: ticketId,
      transactionId: transactionId,
      status: status,
    );
  }

  Future<void> completePorterTransaction({
    // required String ticketId,
    required String transactionId,
    required String porterOnlineId,
  }) {
    return _repository.completePorterTransaction(
      // ticketId: ticketId,
      transactionId: transactionId,
      porterOnlineId: porterOnlineId,
    );
  }
}

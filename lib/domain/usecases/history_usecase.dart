import 'package:e_porter/domain/repositories/history_repository.dart';

import '../models/transaction_model.dart';

class HistoryUseCase {
  final HistoryRepository _repository;

  HistoryUseCase(this._repository);

  Stream<List<TransactionModel>> getPendingTransactionsStream(String userId) {
    return _repository.getTransactionsStream(userId, 'pending');
  }

  Stream<List<TransactionModel>> getActiveTransactionsStream(String userId) {
    return _repository.getTransactionsStream(userId, 'active');
  }

  Stream<List<TransactionModel>> getHistoryTransactionsStream(String uid) {
    return _repository.getHistoryTransactionsStream(uid);
  }

  Future<TransactionModel?> getTransactionFromFirestore(String ticketId, String transactionId) {
    return _repository.getTransactionFromFirestore(ticketId, transactionId);
  }
}

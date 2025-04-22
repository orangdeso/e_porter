import 'package:e_porter/domain/repositories/history_repository.dart';

import '../models/transaction_model.dart';

class HistoryUseCase {
  final HistoryRepository _repository;

  HistoryUseCase(this._repository);

  // Mendapatkan transaksi dengan status pending secara realtime
  Stream<List<TransactionModel>> getPendingTransactionsStream(String userId) {
    return _repository.getTransactionsStream(userId, 'pending');
  }

  // Mendapatkan transaksi dengan status active secara realtime
  Stream<List<TransactionModel>> getActiveTransactionsStream(String userId) {
    return _repository.getTransactionsStream(userId, 'active');
  }

  Future<TransactionModel?> getTransactionFromFirestore(String ticketId, String transactionId) {
    return _repository.getTransactionFromFirestore(ticketId, transactionId);
  }
}

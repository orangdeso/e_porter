import 'dart:async';
import 'dart:developer';
import 'package:e_porter/domain/usecases/history_usecase.dart';
import 'package:get/get.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/models/transaction_model.dart';

class HistoryController extends GetxController {
  final HistoryUseCase _historyUseCase;

  final RxList<TransactionModel> pendingTransactions = <TransactionModel>[].obs;
  final RxList<TransactionModel> activeTransactions = <TransactionModel>[].obs;
  final Rx<TransactionModel?> selectedTransaction = Rx<TransactionModel?>(null);

  final RxBool isLoading = true.obs;
  final RxBool isCheckingExpiry = false.obs;
  final RxString errorMessage = ''.obs;

  StreamSubscription? _pendingSubscription;
  StreamSubscription? _activeSubscription;

  String _currentUserId = '';

  HistoryController(this._historyUseCase);

  void initStreams(String userId) {
    isLoading.value = true;
    _currentUserId = userId;
    log('HistoryController: initStreams dipanggil dengan userId: $userId');

    _cleanupStreams();

    _pendingSubscription = _historyUseCase.getPendingTransactionsStream(userId).listen((transactions) {
      log('HistoryController: pending transactions updated, count: ${transactions.length}');

      final sortedTransactions = _sortTransactionsByCreatedAt(transactions);
      pendingTransactions.value = sortedTransactions;

      isLoading.value = false;
    }, onError: (error) {
      log('HistoryController: Error mendapatkan transaksi pending: $error');
      isLoading.value = false;
    });

    _activeSubscription = _historyUseCase.getActiveTransactionsStream(userId).listen((transactions) {
      log('HistoryController: active transactions updated, count: ${transactions.length}');

      final sortedTransactions = _sortTransactionsByCreatedAt(transactions);
      activeTransactions.value = sortedTransactions;

      isLoading.value = false;
    }, onError: (error) {
      log('HistoryController: Error mendapatkan transaksi active: $error');
      isLoading.value = false;
    });
  }

  List<TransactionModel> _sortTransactionsByCreatedAt(List<TransactionModel> transactions) {
    final sortedList = List<TransactionModel>.from(transactions);

    sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    log('HistoryController: transaksi telah diurutkan berdasarkan createdAt (descending)');

    return sortedList;
  }

  Future<void> checkExpiredPendingTransactions() async {
    final now = DateTime.now();
    final expiredTransactions = pendingTransactions.where((tx) => tx.expiryTime.isBefore(now)).toList();

    if (expiredTransactions.isNotEmpty) {
      log('HistoryController: Ditemukan ${expiredTransactions.length} transaksi kedaluwarsa');

      isCheckingExpiry.value = true;

      for (var transaction in expiredTransactions) {
        log('HistoryController: Menghapus transaksi kedaluwarsa ${transaction.id} dari daftar pending');
        pendingTransactions.removeWhere((tx) => tx.id == transaction.id);
      }

      await Future.delayed(Duration(seconds: 2));
      await Get.find<TransactionRepositoryImpl>().checkAndCancelExpiredTransactions();

      if (_currentUserId.isNotEmpty) {
        await refreshTransactions(_currentUserId);
      }

      isCheckingExpiry.value = false;
    }
  }

  Future<TransactionModel?> getTransactionFromFirestore(String ticketId, String transactionId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      log('HistoryController: mencoba mengambil transaksi dengan ticketId: $ticketId, transactionId: $transactionId');
      final transaction = await _historyUseCase.getTransactionFromFirestore(ticketId, transactionId);

      if (transaction != null) {
        selectedTransaction.value = transaction;
      } else {
        errorMessage.value = 'Transaksi tidak ditemukan';
      }

      return transaction;
    } catch (e) {
      log('HistoryController: error saat mengambil transaksi dari Firestore: $e');
      errorMessage.value = 'Terjadi kesalahan: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTransactions(String userId) async {
    log('HistoryController: Memperbarui data transaksi untuk userId: $userId');

    pendingTransactions.clear();
    activeTransactions.clear();

    isLoading.value = true;

    _cleanupStreams();
    initStreams(userId);

    await Future.delayed(Duration(milliseconds: 500));
  }

  String getUserId() {
    if (_pendingSubscription != null || _activeSubscription != null) {
      return _currentUserId;
    }
    return '';
  }

  void _cleanupStreams() {
    _pendingSubscription?.cancel();
    _activeSubscription?.cancel();
    _pendingSubscription = null;
    _activeSubscription = null;
  }

  @override
  void onClose() {
    _cleanupStreams();
    super.onClose();
  }

  void clearSelectedTransaction() {
    selectedTransaction.value = null;
  }
}

import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';

import '../../data/repositories/transaction_repository_impl.dart';
import '../../presentation/controllers/history_controller.dart';

class TransactionExpiryService {
  static final TransactionExpiryService _instance = TransactionExpiryService._internal();
  late TransactionRepositoryImpl _repository;
  Timer? _timer;
  bool _isRunning = false;

  factory TransactionExpiryService() => _instance;

  TransactionExpiryService._internal();

  void initialize(TransactionRepositoryImpl repository) {
    _repository = repository;
    _startTimer();
    log('[TransactionExpiryService] Service diinisialisasi');
  }

  void _startTimer() {
    if (_isRunning) return;

    _timer?.cancel();
    _isRunning = true;

    _timer = Timer.periodic(Duration(days: 1), (_) {
      _checkExpiredTransactions();
    });

    _checkExpiredTransactions();

    log('[TransactionExpiryService] Timer dimulai, interval: 1 day');
  }

  Future<void> _checkExpiredTransactions() async {
    log('[TransactionExpiryService] Memulai pengecekan transaksi kedaluwarsa...');
    try {
      await _repository.checkAndCancelExpiredTransactions();
      
      try {
        final historyController = Get.find<HistoryController>();
        historyController.checkExpiredPendingTransactions();
      } catch (e) {
        // HistoryController mungkin belum ter-inject, itu normal
        log('[TransactionExpiryService] HistoryController belum tersedia: $e');
      }
      
      log('[TransactionExpiryService] Pengecekan transaksi kedaluwarsa selesai');
    } catch (e) {
      log('[TransactionExpiryService] Error saat memeriksa transaksi kedaluwarsa: $e');
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    log('[TransactionExpiryService] Service dihentikan');
  }

  bool get isRunning => _isRunning;
}

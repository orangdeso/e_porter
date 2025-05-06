import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/domain/models/porter_queue_model.dart';
import 'package:e_porter/presentation/screens/boarding_pass/provider/porter_service_provider.dart';
import 'package:get/get.dart';
import '../../domain/models/transaction_porter_model.dart';
import '../../domain/usecases/transaction_porter_usecase.dart';

class TransactionPorterController extends GetxController {
  final TransactionPorterUsecase _useCase;

  TransactionPorterController(this._useCase);

  final RxList<PorterTransactionModel> transactions = <PorterTransactionModel>[].obs;
  final RxList<PorterTransactionModel> rejectedTransactions = <PorterTransactionModel>[].obs;
  final Rx<PorterTransactionModel?> currentTransaction = Rx<PorterTransactionModel?>(null);
  final Map<String, StreamSubscription<PorterTransactionModel?>> _transactionWatchers = {};
  final RxString currentPorterId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxBool isRejectionDialogVisible = false.obs;
  final RxString rejectionReason = ''.obs;
  final RxString statusFilter = 'pending'.obs;

  final RxBool isRejecting = false.obs;
  final RxBool needsRefresh = false.obs;

  StreamSubscription<List<PorterTransactionModel>>? _subscription;
  StreamSubscription<PorterQueueModel?>? _porterSubscription;
  StreamSubscription<List<PorterTransactionModel>>? _rejectedSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadPorterData();
    _watchRejectedTransactions();
  }

  Future<void> _loadPorterData() async {
    try {
      final userData = await PreferencesService.getUserData();
      if (userData == null || userData.uid.isEmpty) {
        error.value = 'Data user tidak tersedia';
        return;
      }

      String userId = userData.uid;
      currentPorterId.value = userId; // Langsung gunakan userId

      log('Menggunakan userId dari preferences: $userId');
      loadTransactionsFromUserId(userId); // Langsung gunakan userId
    } catch (e) {
      error.value = 'Error inisialisasi: $e';
    }
  }

  void loadTransactionsFromUserId(String userId) {
    if (userId.isEmpty) {
      error.value = 'User ID tidak boleh kosong';
      return;
    }

    isLoading.value = true;
    error.value = '';

    _subscription?.cancel();
    _subscription = _useCase.watchPorterTransactionsByUserId(userId).listen(
      (transactionList) {
        log('[TransactionPorterController] Menerima ${transactionList.length} transaksi dari userId: $userId');

        if (transactionList.isEmpty) {
          log('[TransactionPorterController] Tidak ada transaksi ditemukan untuk userId: $userId');
          if (transactions.isNotEmpty) {
            transactions.clear();
          }
        } else {
          transactions.assignAll(transactionList);

          // Mulai memantau setiap transaksi individual untuk real-time updates
          for (var transaction in transactionList) {
            watchTransaction(transaction.id);
          }
        }

        isLoading.value = false;
      },
      onError: (e) {
        log('[TransactionPorterController] Error streaming transaksi: $e');
        error.value = 'Gagal memuat transaksi: $e';
        isLoading.value = false;
      },
    );
  }

  void watchTransaction(String transactionId) {
    _transactionWatchers[transactionId]?.cancel();
    _transactionWatchers[transactionId] = _useCase.watchTransactionById(transactionId).listen(
      (updatedTransaction) {
        if (updatedTransaction != null) {
          if (currentTransaction.value?.id == transactionId) {
            currentTransaction.value = updatedTransaction;
          }

          final index = transactions.indexWhere((tx) => tx.id == transactionId);
          if (index >= 0) {
            transactions[index] = updatedTransaction;
            log('Transaksi diperbarui secara real-time: $transactionId, status: ${updatedTransaction.status}');
          }
        }
      },
      onError: (error) {
        log('Error memantau transaksi: $error');
      },
    );
  }

  void loadTransactionsFromPorterId(String porterId) {
    if (porterId.isEmpty) {
      error.value = 'Porter ID tidak boleh kosong';
      return;
    }

    isLoading.value = true;
    error.value = '';

    _subscription?.cancel();
    _subscription = _useCase.watchPorterTransactions(porterId).listen((transactionList) {
      log('Menerima ${transactionList.length} transaksi');
      transactions.assignAll(transactionList);

      for (var transaction in transactionList) {
        watchTransaction(transaction.id);
      }

      isLoading.value = false;
    }, onError: (e) {
      log('Error streaming transaksi: $e');
      error.value = 'Gagal memuat transaksi: $e';
      isLoading.value = false;
    });
  }

  Future<PorterTransactionModel?> getTransactionById(String transactionId) async {
    try {
      log('Getting transaction by ID: $transactionId');
      isLoading.value = true;
      error.value = '';
      currentTransaction.value = null;

      final transaction = await _useCase.getTransactionById(transactionId);

      if (transaction != null) {
        log('Transaction found and set to current: ${transaction.id}');
        currentTransaction.value = transaction;

        watchTransaction(transactionId);
      } else {
        log('Transaction not found with ID: $transactionId');
        error.value = 'Transaksi tidak ditemukan';
      }

      return transaction;
    } catch (e) {
      log('Error getting transaction by ID: $e');
      error.value = 'Gagal mendapatkan detail transaksi: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void _watchRejectedTransactions() async {
    try {
      final userData = await PreferencesService.getUserData();
      if (userData == null || userData.uid.isEmpty) {
        log('[Controller] User data tidak ditemukan untuk watching rejected transactions');
        return;
      }

      String porterUserId = userData.uid;
      log('[Controller] Watching rejected transactions for porterUserId: $porterUserId');

      _rejectedSubscription?.cancel();
      _rejectedSubscription = _useCase.watchRejectedTransactionsByPorter(porterUserId).listen(
        (transactions) {
          log('[Controller] Received ${transactions.length} rejected transactions');

          final uniqueTransactions = <String, PorterTransactionModel>{};
          for (var tx in transactions) {
            uniqueTransactions[tx.id] = tx;
          }

          rejectedTransactions.assignAll(uniqueTransactions.values.toList());
        },
        onError: (error) {
          log('[Controller] Error watching rejected transactions: $error');
        },
      );
    } catch (e) {
      log('[Controller] Error setting up rejected transactions watcher: $e');
    }
  }

  Future<PorterTransactionModel?> getRejectedTransactionById(String transactionId) async {
    try {
      log('[TransactionPorterController] Mencari transaksi ditolak dengan ID: $transactionId');

      PorterTransactionModel? rejectedTransaction;
      try {
        rejectedTransaction = rejectedTransactions.firstWhere(
          (tx) => tx.id == transactionId,
        );
      } catch (e) {
        rejectedTransaction = null;
      }

      if (rejectedTransaction != null) {
        // log('[TransactionPorterController] Transaksi ditolak ditemukan di cache');
        currentTransaction.value = rejectedTransaction;
        return rejectedTransaction;
      }

      final userData = await PreferencesService.getUserData();
      if (userData != null && userData.uid.isNotEmpty) {
        String porterUserId = userData.uid;

        final completer = Completer<PorterTransactionModel?>();
        final subscription = _useCase.watchRejectedTransactionsByPorter(porterUserId).listen(
          (transactions) {
            PorterTransactionModel? foundTransaction;
            try {
              foundTransaction = transactions.firstWhere(
                (tx) => tx.id == transactionId,
              );
            } catch (e) {
              foundTransaction = null;
            }

            if (foundTransaction != null) {
              completer.complete(foundTransaction);
            } else {
              completer.complete(null);
            }
          },
          onError: (error) {
            log('[TransactionPorterController] Error mencari transaksi ditolak: $error');
            completer.complete(null);
          },
        );

        final transaction = await completer.future.timeout(
          Duration(seconds: 3),
          onTimeout: () => null,
        );

        subscription.cancel();

        if (transaction != null) {
          currentTransaction.value = transaction;
          // log('[TransactionPorterController] Transaksi ditolak ditemukan: ${transaction.id}');
        } else {
          // log('[TransactionPorterController] Transaksi ditolak tidak ditemukan: $transactionId');
        }

        return transaction;
      }

      return null;
    } catch (e) {
      log('[TransactionPorterController] Error mendapatkan transaksi ditolak: $e');
      return null;
    }
  }

  Future<void> updateTransactionStatus({
    required String transactionId,
    required String status,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      log('Memperbarui status transaksi: $transactionId menjadi $status');

      await _useCase.updateTransactionStatus(
        transactionId: transactionId,
        status: status,
      );

      final updatedTransaction = await getTransactionById(transactionId);

      if (updatedTransaction != null) {
        final index = transactions.indexWhere((tx) => tx.id == transactionId);
        if (index >= 0) {
          transactions[index] = updatedTransaction;
          log('Transaksi di daftar utama diperbarui: $transactionId dengan status: $status');
        } else {
          log('Transaksi tidak ditemukan di daftar, menyegarkan seluruh daftar');
          refreshTransactions();
        }
      }

      SnackbarHelper.showSuccess('Berhasil', 'Status transaksi berhasil diperbarui');
    } catch (e) {
      log('Error memperbarui status: $e');
      error.value = 'Gagal memperbarui status transaksi: $e';
      SnackbarHelper.showError('Terjadi Kesalahan', 'Status transaksi gagal diperbarui');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectTransaction({
    required String transactionId,
    required String reason,
  }) async {
    try {
      isLoading.value = true;
      isRejecting.value = true;
      error.value = '';

      log('Menolak transaksi: $transactionId dengan alasan: $reason');

      await _useCase.rejectTransaction(
        transactionId: transactionId,
        reason: reason.isEmpty ? 'Tidak ada alasan' : reason,
      );

      needsRefresh.value = true;

      final updatedTransaction = await getTransactionById(transactionId);
      if (updatedTransaction != null) {
        final index = transactions.indexWhere((tx) => tx.id == transactionId);
        if (index >= 0) {
          transactions[index] = updatedTransaction;
          log('Transaksi di daftar utama diperbarui menjadi ditolak: $transactionId');
        } else {
          refreshTransactions();
        }
      }

      await Future.delayed(Duration(milliseconds: 500));

      try {
        log('[TransactionPorterController] Memaksa pengecekan reassignment...');
        await PorterServiceProvider.forceReassignmentCheck();
      } catch (reassignError) {
        log('[TransactionPorterController] Error saat memaksa reassignment: $reassignError');
      }

      SnackbarHelper.showSuccess('Berhasil', 'Transaksi berhasil ditolak');
    } catch (e) {
      log('Error menolak transaksi: $e');
      error.value = 'Gagal menolak transaksi: $e';
      SnackbarHelper.showError('Gagal', 'Transaksi gagal ditolak: ${e.toString()}');
    } finally {
      isLoading.value = false;
      isRejecting.value = false;

      if (needsRefresh.value) {
        await refreshTransactions();
        needsRefresh.value = false;
      }
    }
  }

  Future<void> completePorterTransaction({
    required String transactionId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final transaction = currentTransaction.value;
      if (transaction == null) {
        throw Exception('Tidak dapat menemukan data transaksi');
      }

      final porterOnlineId = transaction.porterOnlineId;
      if (porterOnlineId.isEmpty) {
        throw Exception('ID Porter Online tidak ditemukan');
      }

      log('Menyelesaikan transaksi: $transactionId dengan porter: $porterOnlineId');

      await _useCase.completePorterTransaction(
        transactionId: transactionId,
        porterOnlineId: porterOnlineId,
      );

      final updatedTransaction = await getTransactionById(transactionId);

      if (updatedTransaction != null) {
        final index = transactions.indexWhere((tx) => tx.id == transactionId);
        if (index >= 0) {
          transactions[index] = updatedTransaction;
          log('Transaksi di daftar utama diperbarui menjadi selesai: $transactionId');
        } else {
          refreshTransactions();
        }
      }

      SnackbarHelper.showSuccess('Transaksi Selesai', 'Transaksi porter berhasil diselesaikan');
    } catch (e) {
      log('Error menyelesaikan transaksi: $e');
      error.value = 'Gagal menyelesaikan transaksi: $e';
      SnackbarHelper.showError('Terjadi Kesalahan', 'Gagal menyelesaikan transaksi');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTransactions() async {
    final id = currentPorterId.value;
    if (id.isEmpty) {
      try {
        final userData = await PreferencesService.getUserData();
        if (userData != null && userData.uid.isNotEmpty) {
          currentPorterId.value = userData.uid;
          log('Retrieved porter ID from preferences during refresh: ${userData.uid}');
        } else {
          error.value = 'ID porter tidak tersedia';
          return;
        }
      } catch (e) {
        log('Error getting user data for refresh: $e');
        error.value = 'Gagal memperoleh ID porter: $e';
        return;
      }
    }

    log('Refreshing transactions for porter: ${currentPorterId.value}');
    isLoading.value = true;
    loadTransactionsFromPorterId(currentPorterId.value);
  }

  Future<void> refreshRejectedTransactions() async {
    try {
      final userData = await PreferencesService.getUserData();
      if (userData == null || userData.uid.isEmpty) {
        log('[TransactionPorterController] User data tidak ditemukan untuk refresh rejected transactions');
        return;
      }

      String porterUserId = userData.uid;
      log('[TransactionPorterController] Refreshing rejected transactions untuk porterUserId: $porterUserId');

      _rejectedSubscription?.cancel();
      _rejectedSubscription = _useCase.watchRejectedTransactionsByPorter(porterUserId).listen(
        (transactions) {
          log('[TransactionPorterController] Refreshed: ${transactions.length} rejected transactions');
          rejectedTransactions.assignAll(transactions);
        },
        onError: (error) {
          log('[Controller] Error watching rejected transactions: $error');
          if (error is FirebaseException) {
            this.error.value = 'Error loading rejected transactions: ${error.message}';
          } else {
            this.error.value = 'Error loading rejected transactions: $error';
          }
        },
      );
    } catch (e) {
      log('[TransactionPorterController] Error refresh rejected transactions: $e');
    }
  }

  Future<void> forceReassignTransaction(String transactionId) async {
    try {
      isLoading.value = true;
      error.value = '';

      log('[TransactionPorterController] Mencoba mengalihkan transaksi: $transactionId');
      final result = await _useCase.reassignRejectedTransaction(
        transactionId: transactionId,
      );

      if (result != null) {
        await Future.delayed(Duration(milliseconds: 500));

        final updatedTransaction = await getTransactionById(transactionId);
        if (updatedTransaction != null) {
          final index = transactions.indexWhere((tx) => tx.id == transactionId);
          if (index >= 0) {
            transactions[index] = updatedTransaction;
          }
        }

        await refreshTransactions();
        SnackbarHelper.showSuccess('Berhasil', 'Transaksi berhasil dialihkan ke porter lain');
      } else {
        SnackbarHelper.showInfo('Info', 'Tidak ada porter tersedia saat ini, akan dicoba lagi nanti');
      }
    } catch (e) {
      error.value = 'Gagal mengalihkan transaksi: $e';
      SnackbarHelper.showError('Gagal', 'Transaksi gagal dialihkan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<PorterTransactionModel> getFilteredTransactions() {
    return transactions.where((tx) {
      if (statusFilter.value == 'pending') {
        return tx.status == 'pending' && tx.porterOnlineId == currentPorterId.value;
      }
      if (statusFilter.value == 'rejected') {
        return tx.status == 'rejected' && tx.porterOnlineId == currentPorterId.value;
      }
      return tx.normalizedStatus == statusFilter.value && tx.porterOnlineId == currentPorterId.value;
    }).toList();
  }

  void updateStatusFilter(String status) {
    statusFilter.value = status;
  }

  void showRejectDialog() {
    rejectionReason.value = '';
    isRejectionDialogVisible.value = true;
  }

  void hideRejectDialog() {
    isRejectionDialogVisible.value = false;
  }

  @override
  void onClose() {
    _porterSubscription?.cancel();
    _subscription?.cancel();
    _rejectedSubscription?.cancel();
    for (var subscription in _transactionWatchers.values) {
      subscription.cancel();
    }
    _transactionWatchers.clear();
    super.onClose();
  }
}

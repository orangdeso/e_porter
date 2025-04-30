import 'dart:async';
import 'dart:developer';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/domain/models/porter_queue_model.dart';
import 'package:e_porter/presentation/controllers/porter_queue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/models/transaction_porter_model.dart';
import '../../domain/usecases/transaction_porter_usecase.dart';

class TransactionPorterController extends GetxController {
  final TransactionPorterUsecase _useCase;

  TransactionPorterController(this._useCase);

  final RxList<PorterTransactionModel> transactions = <PorterTransactionModel>[].obs;
  final Rx<PorterTransactionModel?> currentTransaction = Rx<PorterTransactionModel?>(null);
  final Map<String, StreamSubscription<PorterTransactionModel?>> _transactionWatchers = {};
  final RxString currentPorterId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final TextEditingController rejectionReasonController = TextEditingController();

  StreamSubscription<List<PorterTransactionModel>>? _subscription;
  StreamSubscription<PorterQueueModel?>? _porterSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadPorterData();
  }

  Future<void> _loadPorterData() async {
    try {
      final userData = await PreferencesService.getUserData();
      if (userData == null || userData.uid.isEmpty) {
        error.value = 'Data user tidak tersedia';
        return;
      }

      // Set userId untuk digunakan nanti
      String userId = userData.uid;
      final porterCtrl = Get.find<PorterQueueController>();

      // Simpan user ID untuk memastikan bisa mengakses history jika porter tidak ditemukan
      String userIdForHistory = userId;

      // Coba mendapatkan porter aktif
      _porterSubscription = porterCtrl.watchPorter(userId).listen((porter) {
        if (porter != null && porter.id != null) {
          log('Porter aktif ditemukan: ${porter.id}');
          currentPorterId.value = porter.id!;

          // Gunakan userId untuk memastikan semua transaksi bisa diakses
          loadTransactionsWithBothIDs(porter.id!, userIdForHistory);
        } else {
          // Porter tidak aktif, coba ambil riwayat dari userId
          log('Porter aktif tidak ditemukan, mencoba ambil riwayat dari userId: $userId');
          loadTransactionsFromUserId(userId);
        }
      }, onError: (e) {
        log('Error memantau data porter: $e');
        // Jika error, coba ambil riwayat dari userId
        loadTransactionsFromUserId(userId);
      });
    } catch (e) {
      error.value = 'Error inisialisasi: $e';
    }
  }

  void loadTransactionsWithBothIDs(String porterId, String userId) {
    isLoading.value = true;
    error.value = '';

    _subscription?.cancel();
    _subscription = _useCase.watchPorterTransactions(porterId).listen((transactionList) {
      log('Menerima ${transactionList.length} transaksi dari porterId');

      // Jika tidak ada transaksi dari porterId, coba dari userId
      if (transactionList.isEmpty && userId != porterId) {
        log('Tidak ada transaksi dari porterId, mencoba dari userId: $userId');
        loadTransactionsFromUserId(userId);
      } else {
        transactions.assignAll(transactionList);
        isLoading.value = false;
      }
    }, onError: (e) {
      log('Error streaming transaksi: $e');

      // Jika terjadi error, coba dari userId sebagai fallback
      if (userId != porterId) {
        log('Error dengan porterId, mencoba dari userId: $userId');
        loadTransactionsFromUserId(userId);
      } else {
        error.value = 'Gagal memuat transaksi: $e';
        isLoading.value = false;
      }
    });
  }

  void loadTransactionsFromUserId(String userId) {
    isLoading.value = true;
    error.value = '';

    log('[TransactionPorterController] Memuat transaksi untuk userId: $userId');

    // Gunakan userId sebagai porterId di porterHistory
    _useCase.getPorterTransactionIds(userId).then((transactionIds) {
      log('[TransactionPorterController] Ditemukan ${transactionIds.length} ID transaksi untuk userId: $userId');

      if (transactionIds.isEmpty) {
        transactions.clear();
        isLoading.value = false;
        return;
      }

      // Ambil dan proses data transaksi
      _processTransactionData(transactionIds);
    }).catchError((e) {
      log('[TransactionPorterController] Error mendapatkan ID transaksi: $e');
      error.value = 'Gagal memuat riwayat transaksi';
      isLoading.value = false;
    });
  }

  void watchTransaction(String transactionId) {
    // Batalkan subscription yang ada jika ada
    _transactionWatchers[transactionId]?.cancel();

    // Mulai subscription baru
    _transactionWatchers[transactionId] = _useCase.watchTransactionById(transactionId).listen(
      (updatedTransaction) {
        if (updatedTransaction != null) {
          // Update current transaction jika itu transaksi yang sedang aktif
          if (currentTransaction.value?.id == transactionId) {
            currentTransaction.value = updatedTransaction;
          }

          // Update transaksi di daftar
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

  void _processTransactionData(List<String> transactionIds) async {
    try {
      List<PorterTransactionModel> txList = [];

      for (var id in transactionIds) {
        final txData = await _useCase.getPorterTransactionById(id);
        if (txData != null) {
          txList.add(PorterTransactionModel.fromJson(txData, id));
        }
      }

      // Urutkan berdasarkan tanggal terbaru
      txList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Update transactions list
      transactions.assignAll(txList);
      isLoading.value = false;
    } catch (e) {
      log('Error memproses data transaksi: $e');
      error.value = 'Gagal memproses data transaksi';
      isLoading.value = false;
    }
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

      // Mulai memantau setiap transaksi individual untuk real-time updates
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

  Future<Map<String, dynamic>?> getPorterTransactionById(String transactionId) async {
    try {
      isLoading.value = true;
      error.value = '';

      return await _useCase.getPorterTransactionById(transactionId);
    } catch (e) {
      log('Error getting transaction data: $e');
      error.value = 'Gagal mendapatkan data transaksi: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<PorterTransactionModel?> getTransactionById(String transactionId) async {
    try {
      log('Getting transaction by ID: $transactionId');
      isLoading.value = true;
      error.value = '';

      // Reset dulu current transaction agar UI bisa merespons ke loading state
      currentTransaction.value = null;

      final transaction = await _useCase.getTransactionById(transactionId);

      if (transaction != null) {
        log('Transaction found and set to current: ${transaction.id}');
        currentTransaction.value = transaction;

        // Mulai memantau transaksi ini
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

      // Dapatkan transaksi yang diperbarui
      final updatedTransaction = await getTransactionById(transactionId);

      // Update list transaksi yang ada dengan yang baru
      if (updatedTransaction != null) {
        // Cari indeks transaksi dalam list yang ada
        final index = transactions.indexWhere((tx) => tx.id == transactionId);
        if (index >= 0) {
          // Update transaksi pada indeks yang ditemukan
          transactions[index] = updatedTransaction;
          log('Transaksi di daftar utama diperbarui: $transactionId dengan status: $status');
        } else {
          // Jika tidak ditemukan, perbarui seluruh list
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
      error.value = '';

      log('Menolak transaksi: $transactionId dengan alasan: $reason');

      // Proses penolakan transaksi
      await _useCase.rejectTransaction(
        transactionId: transactionId,
        reason: reason.isEmpty ? 'Tidak ada alasan' : reason,
      );

      // Segera coba reassign ke porter lain
      try {
        log('Mencoba mengalihkan transaksi yang ditolak ke porter baru...');
        final newTransactionId = await _useCase.reassignRejectedTransaction(
          transactionId: transactionId,
        );

        if (newTransactionId != null) {
          log('Transaksi berhasil dialihkan ke ID baru: $newTransactionId');
          SnackbarHelper.showSuccess('Berhasil', 'Transaksi dialihkan ke porter lain');
        } else {
          // Jika tidak ada porter tersedia saat ini, service di background akan mencoba lagi nanti
          log('Tidak ada porter tersedia saat ini, akan dicoba lagi nanti oleh service');
        }
      } catch (reassignError) {
        log('Error saat mencoba mengalihkan transaksi: $reassignError');
        // Tidak perlu menampilkan error ke user, service akan mencoba lagi nanti
      }

      // Dapatkan transaksi yang diperbarui
      final updatedTransaction = await getTransactionById(transactionId);

      // Update list transaksi yang ada dengan yang baru
      if (updatedTransaction != null) {
        final index = transactions.indexWhere((tx) => tx.id == transactionId);
        if (index >= 0) {
          transactions[index] = updatedTransaction;
          log('Transaksi di daftar utama diperbarui menjadi ditolak: $transactionId');
        } else {
          refreshTransactions();
        }
      }

      // Reset controller alasan
      rejectionReasonController.clear();

      SnackbarHelper.showSuccess('Berhasil', 'Transaksi berhasil ditolak');
    } catch (e) {
      log('Error menolak transaksi: $e');
      error.value = 'Gagal menolak transaksi: $e';
      SnackbarHelper.showError('Terjadi Kesalahan', 'Gagal menolak transaksi');
    } finally {
      isLoading.value = false;
    }
  }

// Metode serupa untuk completePorterTransaction
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

      // Dapatkan transaksi yang diperbarui
      final updatedTransaction = await getTransactionById(transactionId);

      // Update list transaksi
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

  @override
  void onClose() {
    rejectionReasonController.dispose();
    _porterSubscription?.cancel();
    _subscription?.cancel();
    for (var subscription in _transactionWatchers.values) {
      subscription.cancel();
    }
    _transactionWatchers.clear();
    super.onClose();
  }

  void showRejectionDialog(String transactionId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tolak Permintaan Porter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Masukkan alasan penolakan:'),
              const SizedBox(height: 10),
              TextField(
                controller: rejectionReasonController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Sedang melayani penumpang lain',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                rejectionReasonController.clear();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final reason = rejectionReasonController.text.trim();
                Navigator.of(context).pop();
                rejectTransaction(
                  transactionId: transactionId,
                  reason: reason,
                );
              },
              child: const Text('Tolak'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}

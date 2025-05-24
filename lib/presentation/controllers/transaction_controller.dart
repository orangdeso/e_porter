import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:e_porter/domain/models/transaction_model.dart';
import 'package:e_porter/domain/usecases/transaction_usecase.dart';

import '../../data/repositories/transaction_repository_impl.dart';

class TransactionController extends GetxController {
  final TransactionUseCase _transactionUseCase;

  TransactionController(this._transactionUseCase);

  final Rx<TransactionModel?> currentTransaction = Rx<TransactionModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;

  Future<String> createTransaction({
    required String ticketId,
    required String flightId,
    required double amount,
    required String method,
    required DateTime expiryTime,
    required Map<String, dynamic> flightDetails,
    required Map<String, dynamic> bandaraDetails,
    Map<String, dynamic>? porterServiceDetails,
    required Map<String, dynamic> userDetails,
    required int passenger,
    required List<Map<String, dynamic>> passengerDetails, 
    required List<String> numberSeat, 
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final transactionId = await _transactionUseCase.createTransaction(
        ticketId: ticketId,
        flightId: flightId,
        amount: amount,
        method: method,
        expiryTime: expiryTime,
        flightDetails: flightDetails,
        bandaraDetails: bandaraDetails,
        porterServiceDetails: porterServiceDetails,
        userDetails: userDetails,
        passenger: passenger,
        passengerDetails: passengerDetails, 
        numberSeat: numberSeat, 
      );

      final transaction = await _transactionUseCase.getTransactionById(
        ticketId: ticketId,
        transactionId: transactionId,
      );

      currentTransaction.value = transaction;
      return transactionId;
    } catch (e) {
      log('Gagal membuat transaksi: $e');
      error.value = 'Gagal membuat transaksi: $e';
      throw Exception('Gagal membuat transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadPaymentProof({
    required String ticketId,
    required String transactionId,
    required File proofImage,
    required String userId,
  }) async {
    try {
      isUploading.value = true;
      error.value = '';
      uploadProgress.value = 0.0;
      
      await _transactionUseCase.uploadPaymentProof(
        ticketId: ticketId,
        transactionId: transactionId,
        proofImage: proofImage,
        userId: userId,
      );
      
      // Update status transaksi setelah upload berhasil
      await _transactionUseCase.updateTransactionStatus(
        ticketId: ticketId, 
        transactionId: transactionId, 
        status: 'active',
        userId: userId,
      );
      
      // Refresh data transaksi
      final transaction = await _transactionUseCase.getTransactionById(
        ticketId: ticketId, 
        transactionId: transactionId,
      );
      
      currentTransaction.value = transaction;
      
    } catch (e) {
      error.value = 'Gagal mengupload bukti pembayaran: $e';
      throw Exception('Gagal mengupload bukti pembayaran: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Future<List<TransactionModel>> getTransactionsByUserId(String userId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final transactions = await _transactionUseCase.getTransactionsByUserId(userId);
      return transactions;
    } catch (e) {
      log('Gagal mendapatkan daftar transaksi: $e');
      error.value = 'Gagal mendapatkan daftar transaksi: $e';
      throw Exception('Gagal mendapatkan daftar transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTransactionById({required String ticketId, required String transactionId}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final transaction =
          await _transactionUseCase.getTransactionById(ticketId: ticketId, transactionId: transactionId);

      currentTransaction.value = transaction;
    } catch (e) {
      log('Gagal mendapatkan detail transaksi: $e');
      error.value = 'Gagal mendapatkan detail transaksi: $e';
      throw Exception('Gagal mendapatkan detail transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void watchTransaction({required String ticketId, required String transactionId}) {
    try {
      _transactionUseCase.watchTransaction(ticketId: ticketId, transactionId: transactionId).listen(
        (transaction) {
          currentTransaction.value = transaction;
        },
        onError: (e) {
          log('Error mendengarkan perubahan transaksi: $e');
          error.value = 'Error mendengarkan perubahan transaksi: $e';
        },
      );
    } catch (e) {
      log('Gagal memantau transaksi: $e');
      error.value = 'Gagal memantau transaksi: $e';
    }
  }

    Future<void> updateTransactionStatus({
    required String ticketId, 
    required String transactionId, 
    required String status,
    required String userId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _transactionUseCase.updateTransactionStatus(
        ticketId: ticketId, 
        transactionId: transactionId, 
        status: status,
        userId: userId,
      );

      // Refresh data transaksi setelah status diupdate
      final transaction = await _transactionUseCase.getTransactionById(
        ticketId: ticketId, 
        transactionId: transactionId,
      );

      currentTransaction.value = transaction;
    } catch (e) {
      log('Gagal mengupdate status transaksi: $e');
      error.value = 'Gagal mengupdate status transaksi: $e';
      throw Exception('Gagal mengupdate status transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkExpiredTransactions() async {
  try {
    isLoading.value = true;
    error.value = '';
    
    final repository = Get.find<TransactionRepositoryImpl>();
    await repository.checkAndCancelExpiredTransactions();
    
    log('Berhasil memeriksa transaksi kedaluwarsa');
  } catch (e) {
    log('Gagal memeriksa transaksi kedaluwarsa: $e');
    error.value = 'Gagal memeriksa transaksi kedaluwarsa: $e';
  } finally {
    isLoading.value = false;
  }
}
}

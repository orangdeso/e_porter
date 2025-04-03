import 'dart:io';
import 'package:get/get.dart';
import 'package:e_porter/domain/models/transaction_model.dart';
import 'package:e_porter/domain/usecases/transaction_usecase.dart';
import 'package:e_porter/_core/service/logger_service.dart';

class TransactionController extends GetxController {
  final TransactionUseCase _transactionUseCase;

  TransactionController(this._transactionUseCase);

  final Rx<TransactionModel?> currentTransaction = Rx<TransactionModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

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
    required List<Map<String, dynamic>> passengerDetails, // Tambah parameter ini
    required List<String> numberSeat, // Tambah parameter ini
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

      // Ambil data transaksi setelah berhasil dibuat
      final transaction = await _transactionUseCase.getTransactionById(
        ticketId: ticketId,
        transactionId: transactionId,
      );

      currentTransaction.value = transaction;
      return transactionId;
    } catch (e) {
      logger.e('Gagal membuat transaksi: $e');
      error.value = 'Gagal membuat transaksi: $e';
      throw Exception('Gagal membuat transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadPaymentProof(
      {required String ticketId, required String transactionId, required File proofImage}) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _transactionUseCase.uploadPaymentProof(
          ticketId: ticketId, transactionId: transactionId, proofImage: proofImage);

      // Refresh data transaksi setelah bukti pembayaran diunggah
      final transaction =
          await _transactionUseCase.getTransactionById(ticketId: ticketId, transactionId: transactionId);

      currentTransaction.value = transaction;
    } catch (e) {
      logger.e('Gagal mengunggah bukti pembayaran: $e');
      error.value = 'Gagal mengunggah bukti pembayaran: $e';
      throw Exception('Gagal mengunggah bukti pembayaran: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<TransactionModel>> getTransactionsByUserId(String userId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final transactions = await _transactionUseCase.getTransactionsByUserId(userId);
      return transactions;
    } catch (e) {
      logger.e('Gagal mendapatkan daftar transaksi: $e');
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
      logger.e('Gagal mendapatkan detail transaksi: $e');
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
          logger.e('Error mendengarkan perubahan transaksi: $e');
          error.value = 'Error mendengarkan perubahan transaksi: $e';
        },
      );
    } catch (e) {
      logger.e('Gagal memantau transaksi: $e');
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
      logger.e('Gagal mengupdate status transaksi: $e');
      error.value = 'Gagal mengupdate status transaksi: $e';
      throw Exception('Gagal mengupdate status transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

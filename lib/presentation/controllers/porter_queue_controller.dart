import 'dart:developer';

import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/domain/models/porter_queue_model.dart';
import 'package:e_porter/domain/usecases/porter_queue_usecase.dart';
import 'package:get/get.dart';

class PorterQueueController {
  final PorterQueueUsecase _porterQueueUsecase;

  PorterQueueController(this._porterQueueUsecase);

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<PorterQueueModel?> currentPorter = Rx<PorterQueueModel?>(null);

  Future<String> createPorterQueue(String userId, String locationPorter) async {
    try {
      isLoading.value = true;
      error.value = '';

      final porterId = await _porterQueueUsecase.createPorterQueue(userId, locationPorter);

      final porter = await _porterQueueUsecase.getPorterByUserId(userId);
      currentPorter.value = porter;

      return porterId;
    } catch (e) {
      error.value = 'Gagal membuat antrian porter: $e';
      throw Exception(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  bool validatePorterQueueForDeletion() {
    final porter = currentPorter.value;
    if (porter == null || porter.id == null) {
      return false;
    }

    if (porter.idTransaction != null) {
      error.value = 'Porter sedang menangani transaksi, selesaikan transaksi terlebih dahulu';
      return false;
    }

    return true;
  }

  Future<bool> deletePorterQueue(String porterId) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Gunakan metode cek kondisi yang telah diperbaiki
      final canProceed = await checkConditionForPorter(porterId);
      if (!canProceed) {
        return false;
      }

      await _porterQueueUsecase.deletePorterQueue(porterId);
      currentPorter.value = null;

      return true;
    } catch (e) {
      error.value = 'Gagal menghapus antrian porter: $e';
      SnackbarHelper.showError(
        'Gagal',
        'Gagal menghapus antrian porter.',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> validateAndGetUserId(String? userId) async {
    if (userId == null || userId.isEmpty) {
      error.value = 'User ID tidak ditemukan. Silakan login kembali.';
      return null;
    }
    return userId;
  }

  Future<void> loadCurrentPorter(String userId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final porter = await _porterQueueUsecase.getPorterByUserId(userId);
      currentPorter.value = porter;
    } catch (e) {
      error.value = 'Gagal memuat data porter: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Belum

  Future<PorterQueueModel?> getNextAvailablePorter() async {
    try {
      isLoading.value = true;
      error.value = '';

      return await _porterQueueUsecase.getNextAvailablePorter();
    } catch (e) {
      error.value = 'Gagal mendapatkan porter tersedia: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> assignPorterToUser(String porterId, String userId, String transactionId) async {
    try {
      isLoading.value = true;
      error.value = '';

      return await _porterQueueUsecase.assignPorterToUser(porterId, userId, transactionId);
    } catch (e) {
      error.value = 'Gagal menugaskan porter: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, String>> requestPorter({
    required String passengerId,
    required String ticketId,
    required String transactionId,
    required String location,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Panggil usecase dan dapatkan result berupa map
      final result = await _porterQueueUsecase.requestPorter(
        passengerId: passengerId,
        ticketId: ticketId,
        transactionId: transactionId,
        locationPassenger: location,
      );

      return result;
    } catch (e) {
      // Simpan pesan error dan lempar ulang
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completePorterAssignment(String porterId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _porterQueueUsecase.completePorterAssignment(porterId);

      if (currentPorter.value?.id == porterId) {
        final userId = currentPorter.value?.userId;
        if (userId != null) {
          await loadCurrentPorter(userId);
        }
      }
    } catch (e) {
      error.value = 'Gagal menyelesaikan tugas porter: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkConditionForPorter(String porterId) async {
    try {
      isLoading.value = true;
      error.value = '';

      // 1. Dapatkan data terbaru porter langsung dari repository
      final freshPorterData = await _porterQueueUsecase.getPorterById(porterId);

      if (freshPorterData == null) {
        error.value = 'Data porter tidak ditemukan.';
        SnackbarHelper.showError('Gagal', error.value);
        return false;
      }

      // 2. Gunakan data terbaru untuk validasi
      if (freshPorterData.idTransaction != null) {
        error.value = 'Porter sedang menangani transaksi, selesaikan transaksi terlebih dahulu.';
        SnackbarHelper.showError('Gagal', error.value);
        return false;
      }

      if (freshPorterData.idUser != null) {
        error.value = 'Porter masih melayani penumpang, selesaikan tugas terlebih dahulu.';
        SnackbarHelper.showError('Gagal', error.value);
        return false;
      }

      if (freshPorterData.isAvailable != true) {
        error.value = 'Porter belum tersedia untuk keluar antrian.';
        SnackbarHelper.showError('Gagal', error.value);
        return false;
      }

      return true;
    } catch (e) {
      error.value = 'Gagal memeriksa kondisi porter: $e';
      SnackbarHelper.showError('Gagal', 'Gagal memeriksa kondisi porter.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Stream<PorterQueueModel?> watchPorter(String userId) {
    if (userId.isEmpty) {
      log('[PorterQueueController] Error: userId kosong');
      return Stream.value(null);
    }

    log('[PorterQueueController] Memulai pemantauan porter dengan userId: $userId');
    return _porterQueueUsecase.watchPorterByUserId(userId);
  }

  void setError(String message) {
    error.value = message;
    log('[PorterQueueController] Error: $message');
  }
}

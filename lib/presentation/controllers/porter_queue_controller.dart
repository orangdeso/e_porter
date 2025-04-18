import 'package:e_porter/domain/models/porter_queue_model.dart';
import 'package:e_porter/domain/usecases/porter_queue_usecase.dart';
import 'package:get/get.dart';

class PorterQueueController {
  final PorterQueueUsecase _porterQueueUsecase;

  PorterQueueController(this._porterQueueUsecase);

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<PorterQueueModel?> currentPorter = Rx<PorterQueueModel?>(null);

  Future<String> createPorterQueue(String userId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final porterId = await _porterQueueUsecase.createPorterQueue(userId);

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
    return porter != null && porter.id != null;
  }

  Future<bool> deletePorterQueue(String porterId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _porterQueueUsecase.deletePorterQueue(porterId);
      currentPorter.value = null; 

      return true;
    } catch (e) {
      error.value = 'Gagal menghapus antrian porter: $e';
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
}

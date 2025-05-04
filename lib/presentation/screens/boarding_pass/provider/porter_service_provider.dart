import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/_core/service/transaction_reassignment_service.dart';
import 'package:e_porter/data/repositories/transaction_porter_repository_impl.dart';
import 'package:e_porter/domain/usecases/transaction_porter_usecase.dart';
import 'package:e_porter/presentation/controllers/transaction_porter_controller.dart';
import 'package:get/get.dart';

class PorterServiceProvider {
  static TransactionReassignmentService? _reassignmentService;
  static bool _isInitialized = false;

  /// Inisialisasi layanan Porter
  static void initServices() {
    if (_isInitialized) {
      log('[PorterServiceProvider] Layanan Porter sudah diinisialisasi sebelumnya');
      return;
    }

    log('[PorterServiceProvider] Menginisialisasi layanan Porter');

    // Inisialisasi service reassignment transaksi hanya dengan Firestore
    _reassignmentService = TransactionReassignmentService(firestore: FirebaseFirestore.instance);

    // Mulai service dengan interval 30 detik untuk pengujian
    _reassignmentService!.startService(intervalSeconds: 30);

    _isInitialized = true;
  }

  /// Menghentikan layanan Porter
  static void stopServices() {
    log('[PorterServiceProvider] Menghentikan layanan Porter');

    if (_reassignmentService != null) {
      _reassignmentService!.stopService();
      _reassignmentService = null;
    }

    _isInitialized = false;
  }

  /// Inisialisasi controller dan repository
  static void registerDependencies() {
    log('[PorterServiceProvider] Mendaftarkan dependencies Porter');

    // Register Repository jika belum terdaftar - hanya menggunakan Firestore
    if (!Get.isRegistered<TransactionPorterRepositoryImpl>()) {
      Get.lazyPut<TransactionPorterRepositoryImpl>(
          () => TransactionPorterRepositoryImpl(firestore: FirebaseFirestore.instance),
          fenix: true // Mempertahankan instance meskipun tidak ada yang menggunakan
          );
    }

    // Register UseCase
    if (!Get.isRegistered<TransactionPorterUsecase>()) {
      Get.lazyPut<TransactionPorterUsecase>(() => TransactionPorterUsecase(Get.find<TransactionPorterRepositoryImpl>()),
          fenix: true);
    }

    // Register Controller
    if (!Get.isRegistered<TransactionPorterController>()) {
      Get.lazyPut<TransactionPorterController>(() => TransactionPorterController(Get.find<TransactionPorterUsecase>()),
          fenix: true);
    }

    log('[PorterServiceProvider] Dependencies Porter berhasil terdaftar');
  }

  /// Paksa reassignment untuk transaksi yang ditolak
  static Future<void> forceReassignmentCheck() async {
    log('[PorterServiceProvider] Memaksa pengecekan reassignment');
    if (_reassignmentService == null) {
      _reassignmentService = TransactionReassignmentService(firestore: FirebaseFirestore.instance);
    }

    try {
      await _reassignmentService!.forceReassignmentCheck();
    } catch (e) {
      log('[PorterServiceProvider] Error saat memaksa reassignment: $e');
      try {
        resetReassignmentService();
        await _reassignmentService!.forceReassignmentCheck();
      } catch (fallbackError) {
        log('[PorterServiceProvider] Fallback juga gagal: $fallbackError');
      }
    }
  }

  /// Reset TransactionReassignmentService jika diperlukan
  static void resetReassignmentService() {
    if (_reassignmentService != null) {
      _reassignmentService!.stopService();
    }

    _reassignmentService = TransactionReassignmentService(firestore: FirebaseFirestore.instance);
    _reassignmentService!.startService(intervalSeconds: 30);
  }
}

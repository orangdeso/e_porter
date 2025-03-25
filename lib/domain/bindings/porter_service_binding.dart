// domain/bindings/porter_service_binding.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/porter_service_repository.dart';
import '../../data/repositories/porter_service_repository_impl.dart';
import '../../domain/usecases/porter_service_usecase.dart';
import '../../presentation/controllers/porter_service_controller.dart';

class PorterServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Inisialisasi Firestore instance
    final firestore = FirebaseFirestore.instance;
    
    // Repository - Injeksi implementasi ke abstraksi
    Get.lazyPut<PorterServiceRepository>(
      () => PorterServiceRepositoryImpl(firestore: firestore),
    );

    // UseCase
    Get.lazyPut<PorterServiceUseCase>(
      () => PorterServiceUseCase(
        Get.find<PorterServiceRepository>(),
      ),
    );
    
    // Controller
    Get.lazyPut<PorterServiceController>(
      () => PorterServiceController(
        Get.find<PorterServiceUseCase>(),
      ),
    );
  }
}
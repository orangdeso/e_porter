import 'package:get/get.dart';

import '../../data/repositories/profil_repository_impl.dart';
import '../../presentation/controllers/profil_controller.dart';
import '../repositories/profil_repository.dart';
import '../usecases/profil_usecase.dart';

class ProfilBinding extends Bindings {
  @override
  void dependencies() {
    // Injeksi repository
    Get.lazyPut<ProfilRepository>(() => ProfilRepositoryImpl());

    // Injeksi use case, menggunakan repository yang telah di-inject
    Get.lazyPut(() => CreatePassengerUseCase(Get.find()));
    Get.lazyPut(() => GetPassengerByIdUseCase(Get.find()));

    // Injeksi controller, menggunakan use case yang sudah tersedia
    Get.lazyPut(() => ProfilController(
          createPassengerUseCase: Get.find(),
          getPassengerByIdUseCase: Get.find(),
        ));
  }
}

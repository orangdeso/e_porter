import 'package:get/get.dart';

import '../../data/repositories/profil_repository_impl.dart';
import '../../presentation/controllers/profil_controller.dart';
import '../repositories/profil_repository.dart';
import '../usecases/profil_usecase.dart';

class ProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilRepository>(() => ProfilRepositoryImpl());

    Get.lazyPut(() => CreatePassengerUseCase(Get.find()));
    Get.lazyPut(() => GetPassengerByIdUseCase(Get.find()));
    Get.lazyPut(() => GetUserByIdUseCase(Get.find()));

    Get.lazyPut(
      () => ProfilController(
        createPassengerUseCase: Get.find(),
        getPassengerByIdUseCase: Get.find(),
        getUserByIdUseCase: Get.find(),
      ),
    );
  }
}

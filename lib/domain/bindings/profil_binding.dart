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
    Get.lazyPut(() => ChangePasswordUseCase(Get.find()));
    Get.lazyPut(() => ChangePhoneUseCase(Get.find()));
    Get.lazyPut(() => ChangeNoIdUseCase(Get.find()));
    Get.lazyPut(() => DeletePassengerUseCase(Get.find()));
    Get.lazyPut(() => UpdatePassengerUseCase(Get.find()));
    Get.lazyPut(() => UpdateUserDataUseCase(Get.find()));
    // Get.lazyPut(() => ChangeEmailUseCase(Get.find()));

    Get.lazyPut(
      () => ProfilController(
        createPassengerUseCase: Get.find(),
        getPassengerByIdUseCase: Get.find(),
        getUserByIdUseCase: Get.find(),
        changePasswordUseCase: Get.find(),
        changePhoneUseCase: Get.find(),
        changeNoIdUseCase: Get.find(),
        deletePassengerUseCase: Get.find(),
        updatePassengerUseCase: Get.find(),
        updateUserDataUseCase: Get.find(),
      ),
    );
  }
}

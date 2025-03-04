import 'package:e_porter/data/repositories/auth_repository_impl.dart';
import 'package:e_porter/domain/usecases/auth_usecase.dart';
import 'package:e_porter/presentation/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final authRepository = AuthRepositoryImpl(firebaseAuth);

    final loginUseCase = LoginUseCase(authRepository);
    final getUserRoleUseCase = GetUserRoleUseCase(authRepository); // <-- baru

    Get.put<AuthController>(
      AuthController(
        loginUseCase: loginUseCase,
        getUserRoleUseCase: getUserRoleUseCase,
      ),
    );
  }
}

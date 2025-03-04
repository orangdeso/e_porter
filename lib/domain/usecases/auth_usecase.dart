import 'package:e_porter/domain/models/user_entity.dart';
import 'package:e_porter/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<UserEntity> call(String email, String password) async {
    return await authRepository.signInWithEmailPassword(email, password);
  }
}

class GetUserRoleUseCase {
  final AuthRepository authRepository;
  GetUserRoleUseCase(this.authRepository);

  Future<String?> call(String uid) async {
    return await authRepository.getUserRole(uid);
  }
}
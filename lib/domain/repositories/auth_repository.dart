import 'package:e_porter/domain/models/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmailPassword(String email, String password);
  Future<void> signOut();

  Future<String?> getUserRole(String uid);
  Future<UserData?> getUserData(String uid);

  Future<UserEntity> registerWithEmailPassword(String email, String password);
  Future<void> saveUserData(UserData userData);

  Future<void> sendPasswordResetEmail(String email);
  Future<void> confirmPasswordReset(String code, String newPassword);
  
}

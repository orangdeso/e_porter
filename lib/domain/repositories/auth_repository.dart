import 'package:e_porter/domain/models/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmailPassword(String email, String password);
  Future<void> signOut();
  
  Future<String?> getUserRole(String uid);
  Future<UserData?> getUserData(String uid);

}
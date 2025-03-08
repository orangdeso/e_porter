import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/domain/models/user_entity.dart';
import 'package:e_porter/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<UserEntity> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      return UserEntity(uid: user.uid, email: user.email ?? "");
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException code: ${e.code}");
      print("FirebaseAuthException message: ${e.message}");

      switch (e.code) {
        case 'invalid-email':
          throw AuthException("Format email tidak valid.");
        case 'user-not-found':
          throw AuthException("Email tidak terdaftar.");
        case 'wrong-password':
          throw AuthException("Password salah.");
        case 'invalid-credential':
          throw AuthException("Email tidak terdaftar atau password salah.");
        default:
          throw AuthException(e.message ?? "Terjadi kesalahan.");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<String?> getUserRole(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      return data?['role'] as String?;
    } else {
      return null;
    }
  }

  @override
  Future<UserData?> getUserData(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        return UserData.fromMap(data);
      }
    }
    return null;
  }
}

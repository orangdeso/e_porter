import 'dart:developer';

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

      await user.reload();
      if (!user.emailVerified) {
        await _firebaseAuth.signOut();
        throw AuthException("email-not-verified");
      }

      return UserEntity(uid: user.uid, email: user.email ?? "");
    } on FirebaseAuthException catch (e) {
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
  Future<UserEntity> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      await user.sendEmailVerification();
      await user.updateDisplayName(email);

      return UserEntity(uid: user.uid, email: user.email ?? "");
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException code: ${e.code}");
      log("FirebaseAuthException message: ${e.message}");

      throw AuthException(e.code);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> saveUserData(UserData userData) async {
    try {
      await _firestore.collection('users').doc(userData.uid).set(
            userData.toMap(),
            SetOptions(merge: true),
          );

      log("User data berhasil disimpan ke Firestore");
    } catch (e) {
      log("Error saving user data: $e");
      throw AuthException("Gagal menyimpan data pengguna.");
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
        final userData = UserData.fromMap(data);
        final updatedUserData = userData.copyWith(uid: docSnapshot.id);
        return updatedUserData;
      }
    }
    return null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Gagal mengirim email reset.");
    }
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _firebaseAuth.verifyPasswordResetCode(code);
      await _firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Gagal mengganti password.");
    }
  }
}

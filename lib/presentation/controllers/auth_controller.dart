import 'package:e_porter/domain/usecases/auth_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/routes/app_rountes.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final GetUserRoleUseCase getUserRoleUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  AuthController({
    required this.loginUseCase,
    required this.getUserRoleUseCase,
  });

  Future<void> login({String? roleFromOnboarding}) async {
    errorMessage.value = '';

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnackbar("Error", "Email/Password tidak boleh kosong");
      return;
    }
    isLoading.value = true;

    try {
      final userEntity = await loginUseCase(
        emailController.text,
        passwordController.text,
      );
      final uid = userEntity.uid;
      final roleFromDB = await getUserRoleUseCase(uid);
      print("roleFromDB: $roleFromDB, roleFromOnboarding: $roleFromOnboarding");

      if (roleFromDB != null && roleFromOnboarding != null && roleFromDB != roleFromOnboarding) {
        _showErrorSnackbar(
            "Role Tidak Sesuai", "Akun ini terdaftar sebagai '$roleFromDB', bukan '$roleFromOnboarding'.");
        return;
      }

      final effectiveRole = roleFromDB ?? roleFromOnboarding ?? 'penumpang';
      Get.offAllNamed(Routes.NAVBAR, arguments: effectiveRole);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _showErrorSnackbar("Login Gagal", "Email belum terdaftar.");
          break;
        case 'wrong-password':
          _showErrorSnackbar("Login Gagal", "Password salah.");
          break;
        case 'invalid-email':
          _showErrorSnackbar("Login Gagal", "Format email tidak valid.");
          break;
        default:
          _showErrorSnackbar("Login Gagal", e.message ?? "Terjadi kesalahan.");
      }
    } catch (e) {
      _showErrorSnackbar("Terjadi Kesalahan", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

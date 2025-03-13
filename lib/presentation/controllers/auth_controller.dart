import 'package:e_porter/data/repositories/auth_repository_impl.dart';
import 'package:e_porter/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../_core/service/logger_service.dart';
import '../../_core/service/preferences_service.dart';
import '../screens/routes/app_rountes.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final GetUserRoleUseCase getUserRoleUseCase;
  final GetUserDataUseCase getUserDataUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  AuthController({
    required this.loginUseCase,
    required this.getUserRoleUseCase,
    required this.getUserDataUseCase,
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
      logger.d("roleFromDB: $roleFromDB, roleFromOnboarding: $roleFromOnboarding, UID: $uid");

      if (roleFromDB != null && roleFromOnboarding != null && roleFromDB != roleFromOnboarding) {
        _showErrorSnackbar(
            "Role Tidak Sesuai", "Akun ini terdaftar sebagai '$roleFromDB', bukan '$roleFromOnboarding'.");
        return;
      }

      final effectiveRole = roleFromDB ?? roleFromOnboarding ?? 'penumpang';

      final userData = await getUserDataUseCase(uid);
      if (userData == null) {
        _showErrorSnackbar("Login Gagal", "Data user tidak ditemukan.");
        return;
      }

      if (userData.role!.toLowerCase() != effectiveRole.toLowerCase()) {
        _showErrorSnackbar(
            "Role Tidak Sesuai", "Data user menunjukkan role '${userData.role}', bukan '$effectiveRole'.");
        return;
      }

      await PreferencesService.saveUserData(userData);
      Get.offAllNamed(Routes.NAVBAR, arguments: effectiveRole);
    } on AuthException catch (e) {
      _showErrorSnackbar("Login Gagal", e.message);
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

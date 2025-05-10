import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:e_porter/data/repositories/auth_repository_impl.dart';
import 'package:e_porter/domain/models/user_entity.dart';
import 'package:e_porter/domain/usecases/auth_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../_core/service/logger_service.dart';
import '../../_core/service/preferences_service.dart';
import '../screens/routes/app_rountes.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final GetUserRoleUseCase getUserRoleUseCase;
  final GetUserDataUseCase getUserDataUseCase;
  final RegisterUseCase registerUseCase;
  final SaveUserDataUseCase saveUserDataUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  AuthController({
    required this.loginUseCase,
    required this.getUserRoleUseCase,
    required this.getUserDataUseCase,
    required this.registerUseCase,
    required this.saveUserDataUseCase,
  });

  Future<void> login({String? roleFromOnboarding}) async {
    errorMessage.value = '';

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      SnackbarHelper.showError("Error", "Email/Password tidak boleh kosong");
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
        SnackbarHelper.showError(
            "Role Tidak Sesuai", "Akun ini terdaftar sebagai '$roleFromDB', bukan '$roleFromOnboarding'.");
        return;
      }

      final effectiveRole = roleFromDB ?? roleFromOnboarding ?? 'penumpang';

      final userData = await getUserDataUseCase(uid);
      if (userData == null) {
        SnackbarHelper.showError("Login Gagal", "Data user tidak ditemukan.");
        return;
      }

      if (userData.role!.toLowerCase() != effectiveRole.toLowerCase()) {
        SnackbarHelper.showError(
            "Role Tidak Sesuai", "Data user menunjukkan role '${userData.role}', bukan '$effectiveRole'.");
        return;
      }

      await PreferencesService.saveUserData(userData);
      Get.offAllNamed(Routes.NAVBAR, arguments: effectiveRole);
    } on AuthException catch (e) {
      if (e.message == 'email-not-verified') {
        SnackbarHelper.showError(
          "Verifikasi Diperlukan",
          "Silakan cek email Anda dan klik link verifikasi sebelum login.",
        );
      } else {
        SnackbarHelper.showError(
          "Login Gagal",
          "Email atau password anda salah.",
        );
      } 
    } catch (e) {
      SnackbarHelper.showError("Terjadi Kesalahan", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    errorMessage.value = '';
    isLoading.value = true;

    try {
      final userEntity = await registerUseCase(
        email.trim(),
        password,
      );

      final userData = UserData(
        uid: userEntity.uid,
        tipeId: null,
        noId: null,
        name: name.trim(),
        email: email.trim(),
        phone: null,
        birthDate: null,
        gender: null,
        work: null,
        city: null,
        address: null,
        role: role,
      );

      await saveUserDataUseCase(userData);

      SnackbarHelper.showSuccess(
        "Berhasil",
        "Akun berhasil dibuat. Silakan cek email Anda untuk verifikasi terlebih dahulu.",
      );

      Get.offNamed(Routes.VERIFICATION);
    } on AuthException catch (e) {
      switch (e.message) {
        case 'weak-password':
          SnackbarHelper.showError("Error", "Password terlalu lemah.");
          break;
        case 'email-already-in-use':
          SnackbarHelper.showError("Error", "Email sudah terdaftar.");
          break;
        case 'invalid-email':
          SnackbarHelper.showError("Error", "Format email tidak valid.");
          break;
        default:
          SnackbarHelper.showError("Registrasi Gagal", "Terjadi kesalahan saat registrasi.");
      }
    } catch (e) {
      SnackbarHelper.showError("Terjadi Kesalahan", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackbarHelper.showError("Error", "User tidak ditemukan.");
      return;
    }
    if (user.emailVerified) {
      SnackbarHelper.showSuccess("Sudah Terverifikasi", "Email Anda sudah terverifikasi.");
      return;
    }
    try {
      await user.sendEmailVerification();
      SnackbarHelper.showSuccess(
        "Terkirim",
        "Link verifikasi telah dikirim ulang ke email Anda.",
      );
    } on FirebaseException catch (e) {
      if (e.message?.contains('No AppCheckProvider') == true) {
        SnackbarHelper.showSuccess(
          "Terkirim",
          "Link verifikasi telah dikirim ulang ke email Anda.",
        );
      } else {
        SnackbarHelper.showError(
          "Gagal",
          "Gagal mengirim ulang verifikasi. Silakan coba lagi.",
        );
      }
    } catch (e) {
      SnackbarHelper.showError(
        "Gagal",
        "Gagal mengirim ulang verifikasi. Silakan coba lagi.",
      );
    }
  }

  Future<void> completeEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await user.reload();

    if (user.emailVerified) {
      final userData = await getUserDataUseCase(user.uid);
      if (userData != null) {
        await PreferencesService.saveUserData(userData);
      }
      Get.offAllNamed(Routes.NAVBAR, arguments: userData?.role);
    }
  }

  // void _showErrorSnackbar(String title, String message) {
  //   Get.snackbar(
  //     title,
  //     message,
  //     snackPosition: SnackPosition.TOP,
  //     backgroundColor: Colors.red,
  //     colorText: Colors.white,
  //   );
  // }
}

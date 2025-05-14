import 'dart:developer';
import 'package:e_porter/_core/service/logger_service.dart';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:e_porter/_core/utils/snackbar/snackbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../domain/models/user_entity.dart';
import '../../domain/usecases/profil_usecase.dart';

class ProfilController extends GetxController {
  final CreatePassengerUseCase createPassengerUseCase;
  final GetPassengerByIdUseCase getPassengerByIdUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final ChangePhoneUseCase changePhoneUseCase;
  // final ChangeEmailUseCase changeEmailUseCase;

  var passengerList = <PassengerModel>[].obs;
  var userData = Rxn<UserData>();
  var isLoading = false.obs;
  var isChangingPassword = false.obs;
  var isChangingPhone = false.obs;
  // var isChangingEmail = false.obs;

  ProfilController({
    required this.createPassengerUseCase,
    required this.getPassengerByIdUseCase,
    required this.getUserByIdUseCase,
    required this.changePasswordUseCase,
    required this.changePhoneUseCase,
    // required this.changeEmailUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  // Future<void> reloadProfile() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;
  //   final uid = user.uid;

  //   await FirebaseFirestore.instance.collection('users').doc(uid).update({'email': user.email});

  //   final fresh = await getUserByIdUseCase(uid);
  //   userData.value = fresh;

  //   await PreferencesService.saveUserData(fresh);
  // }

  Future<void> _loadProfile() async {
    isLoading.value = true;
    try {
      final cached = await PreferencesService.getUserData();
      String? uid = cached?.uid;
      uid ??= FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        log("Tidak ditemukan user yang sedang login");
        return;
      }

      final fresh = await getUserByIdUseCase(uid);
      userData.value = fresh;
      await PreferencesService.saveUserData(fresh);
    } catch (e) {
      log("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPassenger({
    required String userId,
    required String typeId,
    required String noId,
    required String name,
    required String gender,
  }) async {
    final passenger = PassengerModel(
      typeId: typeId,
      noId: noId,
      name: name,
      gender: gender,
    );
    await createPassengerUseCase(
      userId: userId,
      passenger: passenger,
    );
  }

  Future<void> fetchPassangerById(String userId) async {
    try {
      List<PassengerModel> list = await getPassengerByIdUseCase(userId);
      passengerList.assignAll(list);
    } catch (e) {
      logger.e("Error fetching passengers: $e");
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    isChangingPassword.value = true;
    try {
      await changePasswordUseCase(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      SnackbarHelper.showSuccess("Berhasil", "Password berhasil diperbarui.");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        SnackbarHelper.showError("Gagal", "Password lama salah.");
      } else if (e.code == 'weak-password') {
        SnackbarHelper.showError("Gagal", "Password baru terlalu lemah.");
      } else {
        SnackbarHelper.showError("Gagal", "Error: ${e.message}");
      }
      return false;
    } catch (e) {
      SnackbarHelper.showError("Gagal", "Terjadi kesalahan.");
      return false;
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<bool> changePhone({
    required String oldPassword,
    required String newPhone,
  }) async {
    isChangingPhone.value = true;
    try {
      await changePhoneUseCase(
        oldPassword: oldPassword,
        newPhone: newPhone,
      );
      await _loadProfile();
      SnackbarHelper.showSuccess("Berhasil", "Nomor telepon berhasil diperbarui.");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        SnackbarHelper.showError("Gagal", "Password lama salah.");
      } else {
        SnackbarHelper.showError("Gagal", e.message ?? "Terjadi kesalahan.");
      }
      return false;
    } catch (_) {
      SnackbarHelper.showError("Gagal", "Terjadi kesalahan.");
      return false;
    } finally {
      isChangingPhone.value = false;
    }
  }

  // Future<bool> changeEmail({
  //   required String oldPassword,
  //   required String newEmail,
  // }) async {
  //   isChangingEmail.value = true;
  //   try {
  //     await changeEmailUseCase(
  //       oldPassword: oldPassword,
  //       newEmail: newEmail,
  //     );

  //     await reloadProfile();

  //     SnackbarHelper.showSuccess("Berhasil", "Email berhasil diubah. Silakan cek $newEmail untuk verifikasi.");
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case 'wrong-password':
  //       case 'invalid-credential':
  //         SnackbarHelper.showError("Gagal", "Password lama salah.");
  //         break;
  //       case 'email-already-in-use':
  //         SnackbarHelper.showError("Gagal", "Email baru sudah digunakan.");
  //         break;
  //       case 'operation-not-allowed':
  //         SnackbarHelper.showError("Gagal", "Email/Password signin belum diaktifkan di Firebase Console.");
  //         break;
  //       default:
  //         SnackbarHelper.showError("Gagal", e.message ?? e.code);
  //     }
  //     return false;
  //   } finally {
  //     isChangingEmail.value = false;
  //   }
  // }

  // Future<bool> changeEmail({
  //   required String oldPassword,
  //   required String newEmail,
  // }) async {
  //   isChangingEmail.value = true;
  //   try {
  //     await changeEmailUseCase(oldPassword: oldPassword, newEmail: newEmail);
  //     SnackbarHelper.showSuccess("Link Terkirim", "Silakan cek email $newEmail untuk verifikasi.");
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case 'wrong-password':
  //       case 'invalid-credential':
  //         SnackbarHelper.showError("Gagal", "Password lama salah.");
  //         break;
  //       case 'email-already-in-use':
  //         SnackbarHelper.showError("Gagal", "Email baru sudah digunakan.");
  //         break;
  //       case 'unauthorized-domain':
  //         SnackbarHelper.showError(
  //             "Gagal",
  //             "Domain verifikasi belum diizinkan. "
  //                 "Tambahkan \"eporter.page.link\" di Firebase Console → Authentication → Settings → Authorized domains.");
  //         break;
  //       default:
  //         SnackbarHelper.showError("Gagal", e.message ?? e.code);
  //     }
  //     return false;
  //   } catch (_) {
  //     SnackbarHelper.showError("Gagal", "Terjadi kesalahan.");
  //     return false;
  //   } finally {
  //     isChangingEmail.value = false;
  //   }
  // }
}

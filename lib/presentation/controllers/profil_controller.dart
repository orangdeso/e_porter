import 'dart:developer';

import 'package:e_porter/_core/service/logger_service.dart';
import 'package:e_porter/_core/service/preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../domain/models/user_entity.dart';
import '../../domain/usecases/profil_usecase.dart';

class ProfilController extends GetxController {
  final CreatePassengerUseCase createPassengerUseCase;
  final GetPassengerByIdUseCase getPassengerByIdUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  var passengerList = <PassengerModel>[].obs;
  var userData = Rxn<UserData>();
  var isLoading = false.obs;

  ProfilController({
    required this.createPassengerUseCase,
    required this.getPassengerByIdUseCase,
    required this.getUserByIdUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

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
}

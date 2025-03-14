import 'package:e_porter/_core/service/logger_service.dart';
import 'package:get/get.dart';

import '../../domain/models/user_entity.dart';
import '../../domain/usecases/profil_usecase.dart';

class ProfilController extends GetxController {
  final CreatePassengerUseCase createPassengerUseCase;
  final GetPassengerByIdUseCase getPassengerByIdUseCase;

  var passengerList = <PassengerModel>[].obs;

  ProfilController({required this.createPassengerUseCase, required this.getPassengerByIdUseCase});

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

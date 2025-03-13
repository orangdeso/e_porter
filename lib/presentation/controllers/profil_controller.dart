import 'package:get/get.dart';

import '../../domain/models/user_entity.dart';
import '../../domain/usecases/profil_usecase.dart';

class ProfilController extends GetxController {
  final CreatePassengerUseCase createPassengerUseCase;

  ProfilController({required this.createPassengerUseCase});

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
}
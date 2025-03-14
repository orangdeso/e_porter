import '../models/user_entity.dart';

abstract class ProfilRepository {
  Future<void> createPassenger({
    required String userId,
    required PassengerModel passenger,
  });

  Future<List<PassengerModel>> getPassengerById(String userId);
}

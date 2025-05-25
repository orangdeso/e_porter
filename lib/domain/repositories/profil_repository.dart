import '../models/user_entity.dart';

abstract class ProfilRepository {
  Future<void> createPassenger({
    required String userId,
    required PassengerModel passenger,
  });

  Future<List<PassengerModel>> getPassengerById(String userId);

  Future<UserData> getUserById(String userId);

  Future<void> deletePassenger({
    required String userId,
    required String passengerId,
  });

  Future<void> updatePassenger({
    required String userId,
    required String passengerId,
    required PassengerModel passenger,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  
  Future<void> changePhone({
    required String oldPassword,
    required String newPhone,
  });

  Future<void> changeNoId({
    required String oldPassword,
    required String typeId,
    required String noId,
  });

  // Future<void> changeEmail({
  //   required String oldPassword,
  //   required String newEmail,
  // });
}

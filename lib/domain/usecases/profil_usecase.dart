import '../models/user_entity.dart';
import '../repositories/profil_repository.dart';

class CreatePassengerUseCase {
  final ProfilRepository profilRepository;

  CreatePassengerUseCase(this.profilRepository);

  Future<void> call({
    required String userId,
    required PassengerModel passenger,
  }) async {
    await profilRepository.createPassenger(
      userId: userId,
      passenger: passenger,
    );
  }
}

class GetPassengerByIdUseCase {
  final ProfilRepository profilRepository;

  GetPassengerByIdUseCase(this.profilRepository);

  Future<List<PassengerModel>> call(String userId) async {
    return await profilRepository.getPassengerById(userId);
  }
}

class GetUserByIdUseCase {
  final ProfilRepository profilRepository;
  GetUserByIdUseCase(this.profilRepository);

  Future<UserData> call(String userId) => profilRepository.getUserById(userId);
}

class ChangePasswordUseCase {
  final ProfilRepository profilRepository;
  ChangePasswordUseCase(this.profilRepository);

  Future<void> call({
    required String oldPassword,
    required String newPassword,
  }) {
    return profilRepository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}

class ChangePhoneUseCase {
  final ProfilRepository profilRepository;
  ChangePhoneUseCase(this.profilRepository);

  Future<void> call({
    required String oldPassword,
    required String newPhone,
  }) {
    return profilRepository.changePhone(
      oldPassword: oldPassword,
      newPhone: newPhone,
    );
  }
}

class ChangeNoIdUseCase {
  final ProfilRepository profilRepository;
  ChangeNoIdUseCase(this.profilRepository);

  Future<void> call({
    required String oldPassword,
    required String typeId,
    required String noId,
  }) {
    return profilRepository.changeNoId(
      oldPassword: oldPassword,
      typeId: typeId,
      noId: noId,
    );
  }
}

class DeletePassengerUseCase {
  final ProfilRepository profilRepository;
  DeletePassengerUseCase(this.profilRepository);

  Future<void> call({
    required String userId,
    required String passengerId,
  }) {
    return profilRepository.deletePassenger(
      userId: userId,
      passengerId: passengerId,
    );
  }
}

class UpdatePassengerUseCase {
  final ProfilRepository profilRepository;
  UpdatePassengerUseCase(this.profilRepository);

  Future<void> call({
    required String userId,
    required String passengerId,
    required PassengerModel passenger,
  }) {
    return profilRepository.updatePassenger(
      userId: userId,
      passengerId: passengerId,
      passenger: passenger,
    );
  }
}

// class ChangeEmailUseCase {
//   final ProfilRepository profilRepository;
//   ChangeEmailUseCase(this.profilRepository);

//   Future<void> call({
//     required String oldPassword,
//     required String newEmail,
//   }) {
//     return profilRepository.changeEmail(
//       oldPassword: oldPassword,
//       newEmail: newEmail,
//     );
//   }
// }

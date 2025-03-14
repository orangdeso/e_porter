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

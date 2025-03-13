import '../models/user_entity.dart';
import '../repositories/profil_repository.dart';

class CreatePassengerUseCase {
  final ProfilRepository profilRepository;

  CreatePassengerUseCase(this.profilRepository);

  Future<void> call({
    required String userId,
    required PassengerModel passenger,
  }) async {
    // Lakukan validasi atau logika bisnis lain jika diperlukan
    await profilRepository.createPassenger(
      userId: userId,
      passenger: passenger,
    );
  }
}
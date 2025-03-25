import '../models/porter_service_model.dart';

abstract class PorterServiceRepository {
  // Mendapatkan semua layanan porter
  Future<List<PorterServiceModel>> getAllServices();
  
  // Mendapatkan layanan porter berdasarkan tipe (departure, arrival, transit)
  Future<List<PorterServiceModel>> getServicesByType(String type);
}
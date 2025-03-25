// domain/usecases/porter_service_usecase.dart

import '../models/porter_service_model.dart';
import '../repositories/porter_service_repository.dart';

class PorterServiceUseCase {
  final PorterServiceRepository _repository;

  PorterServiceUseCase(this._repository);

  Future<List<PorterServiceModel>> getAllServices() async {
    return await _repository.getAllServices();
  }

  Future<List<PorterServiceModel>> getAllServicesOrderedByUrutan() async {
    final services = await _repository.getAllServices();
    services.sort((a, b) => a.sort.compareTo(b.sort)); 
    return services;
  }
}
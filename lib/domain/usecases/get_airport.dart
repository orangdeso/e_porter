import '../models/airport.dart';
import '../repositories/airport_repository.dart';

class GetAirports {
  final AirportRepository repository;

  GetAirports(this.repository);

  Future<List<Airport>> call() async {
    return await repository.getAirports();
  }
}
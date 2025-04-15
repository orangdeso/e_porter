import '../models/airport.dart';

abstract class AirportRepository {
  Future<List<Airport>> getAirports();
  Future<Airport?> getAirportsById(String id);
}
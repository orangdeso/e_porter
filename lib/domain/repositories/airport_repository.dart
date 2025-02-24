import '../models/airport.dart';

abstract class AirportRepository {
  Future<List<Airport>> getAirports();
}
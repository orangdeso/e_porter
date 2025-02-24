import 'package:get/get.dart';

import '../models/airport.dart';
import '../usecases/get_airport.dart';

class SearchFlightController extends GetxController {
  final GetAirports getAirports;
  var airports = <Airport>[].obs; // Gunakan Rx agar bisa reaktif

  SearchFlightController(this.getAirports);

  @override
  void onInit() {
    super.onInit();
    fetchAirports();
  }

  void fetchAirports() async {
    final result = await getAirports();
    airports.value = result;
  }

  // Misalnya, jika Anda ingin menambahkan pencarian:
  void searchAirports(String query) {
    // Contoh filter sederhana
    final filtered = airports.where((airport) {
      final city = airport.city.toLowerCase();
      final code = airport.code.toLowerCase();
      final name = airport.name.toLowerCase();
      final q = query.toLowerCase();
      return city.contains(q) || code.contains(q) || name.contains(q);
    }).toList();

    airports.value = filtered;
  }
}
import 'package:get/get.dart';

import '../../domain/models/airport.dart';
import '../../domain/usecases/get_airport.dart';

class SearchFlightController extends GetxController {
  final GetAirports getAirports;

  var airports = <Airport>[].obs; // Gunakan Rx agar bisa reaktif
  var filteredAirports = <Airport>[].obs;
  var searchText = ''.obs;

  SearchFlightController(this.getAirports);

  @override
  void onInit() {
    super.onInit();
    fetchAirports();
    debounce(searchText, (_) => searchAirports(searchText.value), time: Duration(milliseconds: 300));
  }

  void fetchAirports() async {
    final result = await getAirports();
    airports.value = result;
    filteredAirports.assignAll(result);
  }

  void searchAirports(String query) {
    final lowerCaseQuery = query.toLowerCase();

    if (lowerCaseQuery.isEmpty) {
      filteredAirports.assignAll(airports);
    } else {
      filteredAirports.assignAll(airports
          .where((airport) =>
              airport.name.toLowerCase().contains(lowerCaseQuery) ||
              airport.city.toLowerCase().contains(lowerCaseQuery) ||
              airport.code.toLowerCase().contains(lowerCaseQuery))
          .toList());
    }
  }
}

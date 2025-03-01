import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/repositories/airport_repository.dart';
import '../../presentation/controllers/search_flight_controller.dart';
import '../usecases/get_airport.dart';

class SearchFlightBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Daftarkan Repository ke GetX
    Get.lazyPut<AirportRepositoryImpl>(
      () => AirportRepositoryImpl(firestore: FirebaseFirestore.instance),
    );

    // 2. Daftarkan UseCase
    Get.lazyPut<GetAirports>(
      () => GetAirports(Get.find<AirportRepositoryImpl>()),
    );

    // 3. Daftarkan Controller
    Get.lazyPut<SearchFlightController>(
      () => SearchFlightController(Get.find<GetAirports>()),
    );
  }
}
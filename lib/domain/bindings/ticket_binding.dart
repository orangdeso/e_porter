import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/repositories/ticket_repository_impl.dart';
import '../../presentation/controllers/ticket_controller.dart';
import '../repositories/ticket_repository.dart';
import '../usecases/ticket_usecase.dart';

class TicketBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Daftarkan Repository
    Get.lazyPut<TicketRepository>(
      () => TicketRepositoryImpl(firestore: FirebaseFirestore.instance),
    );

    // 2. Daftarkan Usecase
    Get.lazyPut<SearchFlightUseCase>(
      () => SearchFlightUseCase(Get.find()),
    );
     Get.lazyPut<GetFlightByIdUseCase>(
      () => GetFlightByIdUseCase(Get.find()),
    );

    // 3. Daftarkan Controller
    Get.lazyPut<TicketController>(
      () => TicketController(Get.find(), Get.find()),
    );
  }
}
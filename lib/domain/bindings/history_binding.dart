import 'package:get/get.dart';

import '../../data/repositories/history_repository_impl.dart';
import '../../presentation/controllers/history_controller.dart';
import '../repositories/history_repository.dart';
import '../usecases/history_usecase.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<HistoryRepository>(
      () => HistoryRepositoryImpl(),
    );

    // Inject UseCase
    Get.lazyPut<HistoryUseCase>(
      () => HistoryUseCase(Get.find<HistoryRepository>()),
    );

    // Inject Controller
    Get.lazyPut<HistoryController>(
      () => HistoryController(Get.find<HistoryUseCase>()),
    );
  }
}
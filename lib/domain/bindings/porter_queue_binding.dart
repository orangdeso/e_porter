import 'package:e_porter/domain/usecases/porter_queue_usecase.dart';
import 'package:e_porter/presentation/controllers/porter_queue_controller.dart';
import 'package:get/get.dart';

import '../../data/repositories/porter_queue_repository_impl.dart';
import '../repositories/porter_queue_repository.dart';

class PorterQueueBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<PorterQueueRepository>(
      () => PorterQueueRepositoryImpl(),
    );
    
    // UseCase
    Get.lazyPut<PorterQueueUsecase>(
      () => PorterQueueUsecase(Get.find<PorterQueueRepository>()),
    );
    
    // Controller
    Get.lazyPut<PorterQueueController>(
      () => PorterQueueController(Get.find<PorterQueueUsecase>()),
    );
  }
}
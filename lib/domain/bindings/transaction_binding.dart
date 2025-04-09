import 'package:get/get.dart';
import 'package:e_porter/domain/repositories/transaction_repository.dart';
import 'package:e_porter/data/repositories/transaction_repository_impl.dart';
import 'package:e_porter/domain/usecases/transaction_usecase.dart';
import 'package:e_porter/presentation/controllers/transaction_controller.dart';

import '../../_core/service/transaction_expiry_service.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepositoryImpl(),
      fenix: true
    );

    Get.lazyPut<TransactionRepositoryImpl>(
      () => TransactionRepositoryImpl(),
      fenix: true,
    );

    Get.lazyPut<TransactionUseCase>(
      () => TransactionUseCase(Get.find<TransactionRepository>()),
    );

    Get.lazyPut<TransactionController>(
      () => TransactionController(Get.find<TransactionUseCase>()),
    );

    TransactionExpiryService().initialize(Get.find<TransactionRepositoryImpl>());
  }
}
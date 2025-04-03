import 'package:get/get.dart';
import 'package:e_porter/domain/repositories/transaction_repository.dart';
import 'package:e_porter/data/repositories/transaction_repository_impl.dart';
import 'package:e_porter/domain/usecases/transaction_usecase.dart';
import 'package:e_porter/presentation/controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepositoryImpl(),
    );

    // UseCase
    Get.lazyPut<TransactionUseCase>(
      () => TransactionUseCase(Get.find<TransactionRepository>()),
    );

    // Controller
    Get.lazyPut<TransactionController>(
      () => TransactionController(Get.find<TransactionUseCase>()),
    );
  }
}
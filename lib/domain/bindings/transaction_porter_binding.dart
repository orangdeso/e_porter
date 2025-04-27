import 'package:get/get.dart';
import '../../domain/repositories/transaction_porter_repository.dart';
import '../../domain/usecases/transaction_porter_usecase.dart';
import '../../data/repositories/transaction_porter_repository_impl.dart';
import '../../presentation/controllers/transaction_porter_controller.dart';

class TransactionPorterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionPorterRepository>(
      () => TransactionPorterRepositoryImpl(),
    );

    // UseCase
    Get.lazyPut<TransactionPorterUsecase>(
      () => TransactionPorterUsecase(Get.find<TransactionPorterRepository>()),
    );

    // Controller
    Get.lazyPut<TransactionPorterController>(
      () => TransactionPorterController(Get.find<TransactionPorterUsecase>()),
    );
  }
}

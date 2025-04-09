import 'package:get/get.dart';
import 'package:e_porter/data/repositories/transaction_repository_impl.dart';
import 'package:e_porter/_core/service/transaction_expiry_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Inisialisasi TransactionExpiryService
    Get.put<TransactionRepositoryImpl>(TransactionRepositoryImpl(), permanent: true);
    
    // Inisialisasi dan mulai service
    final repository = Get.find<TransactionRepositoryImpl>();
    TransactionExpiryService().initialize(repository);
  }
}
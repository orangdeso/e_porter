import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/data/repositories/statistic_repository_impl.dart';
import 'package:e_porter/domain/repositories/statistic_repository.dart';
import 'package:e_porter/domain/usecases/statistic_usecase.dart';
import 'package:e_porter/presentation/controllers/statistic_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StatisticBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<StatisticRepository>(
      () => StatisticRepositoryImpl(FirebaseFirestore.instance),
    );

    // UseCase
    Get.lazyPut(() => StatisticUseCase(Get.find()));

    // Controller: di sini kita ambil current user ID langsung dari FirebaseAuth
    Get.lazyPut(() => StatisticController(
          useCase: Get.find(),
          porterId: FirebaseAuth.instance.currentUser!.uid,
        ));
  }
}

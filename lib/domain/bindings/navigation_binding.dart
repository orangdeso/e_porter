import 'package:e_porter/presentation/controllers/navigation_controller.dart';
import 'package:get/get.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}

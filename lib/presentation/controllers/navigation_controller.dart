import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt currentPage = 0.obs;

  void goToTab(int page) {
    currentPage.value = page;
  }
}

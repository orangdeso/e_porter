import 'dart:developer';

import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt _currentPage = 0.obs;

  // Property untuk Obx
  RxInt get currentPage => _currentPage;

  void goToTab(int page) {
    log("Changing tab to: $page (type: ${page.runtimeType})");

    // Langsung gunakan page sebagai int
    _currentPage.value = page;

    log("Current page is now: ${_currentPage.value} (type: ${_currentPage.value.runtimeType})");
  }
}

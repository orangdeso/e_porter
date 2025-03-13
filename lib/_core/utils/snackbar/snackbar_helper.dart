import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class SnackbarHelper {
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: GreenColors.green500,
      colorText: Colors.white,
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
    );
  }
}

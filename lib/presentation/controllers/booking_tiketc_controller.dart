import 'package:get/get.dart';

class BookingTiketcController extends GetxController {
  var selectedNumber = 1.obs;

  void updateNumber(int newNumber) {
    selectedNumber.value = newNumber;
  }
}

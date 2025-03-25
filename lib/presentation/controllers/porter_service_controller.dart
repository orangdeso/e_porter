// presentation/controllers/porter_service_controller.dart

import 'package:e_porter/_core/service/logger_service.dart';
import 'package:get/get.dart';
import '../../domain/models/porter_service_model.dart';
import '../../domain/usecases/porter_service_usecase.dart';

class PorterServiceController extends GetxController {
  final PorterServiceUseCase _porterServiceUseCase;

  PorterServiceController(this._porterServiceUseCase);

  final RxList<PorterServiceModel> layananPorter = <PorterServiceModel>[].obs;
  final RxList<PorterServiceModel> layananPorterArrival = <PorterServiceModel>[].obs;
  final RxList<PorterServiceModel> layananPorterDeparture = <PorterServiceModel>[].obs;
  final RxList<PorterServiceModel> layananPorterTransit = <PorterServiceModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString pesanError = ''.obs;
  final RxString tipeTerpilih = 'semua'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLayananPorter();
  }

  Future<void> fetchLayananPorter() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      pesanError.value = '';

      final result = await _porterServiceUseCase.getAllServicesOrderedByUrutan();

      layananPorterArrival.assignAll(result.where((service) => service.tersediaUntuk.contains('departure')).toList());
      layananPorterDeparture.assignAll(result.where((service) => service.tersediaUntuk.contains('arrival')).toList());
      layananPorterTransit.assignAll(result.where((service) => service.tersediaUntuk.contains('transit')).toList());
    } catch (e) {
      logger.e('Error mendapatkan layanan porter: $e');
      hasError.value = true;
      pesanError.value = 'Terjadi kesalahan saat memuat layanan porter.';
    } finally {
      isLoading.value = false;
    }
  }

  bool isTipeAktif(String tipe) {
    return tipe == 'arrival' || tipe == 'departure' || tipe == 'transit';
  }
}

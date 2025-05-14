import 'package:e_porter/domain/usecases/statistic_usecase.dart';
import 'package:get/get.dart';

class StatisticController extends GetxController {
  final StatisticUseCase useCase;
  final String porterId;

  final date = DateTime.now().obs;

  final incoming   = 0.obs;
  final inProgress = 0.obs;
  final completed  = 0.obs;
  final revenue    = 0.0.obs;

  StatisticController({
    required this.useCase,
    required this.porterId,
  });

  @override
  void onInit() {
    super.onInit();
    _bindAllStreams();
    ever(date, (_) => _bindAllStreams());
  }

  void _bindAllStreams() {
    incoming.bindStream(
      useCase.getIncomingOrders(porterId: porterId, date: date.value),
    );
    inProgress.bindStream(
      useCase.getInProgressOrders(porterId: porterId, date: date.value),
    );
    completed.bindStream(
      useCase.getCompletedOrders(porterId: porterId, date: date.value),
    );
    revenue.bindStream(
      useCase.getRevenue(porterId: porterId, date: date.value),
    );
  }

  void changeDate(DateTime newDate) => date.value = newDate;
}

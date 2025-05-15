import 'package:e_porter/domain/repositories/statistic_repository.dart';

class StatisticUseCase {
  final StatisticRepository _repo;
  StatisticUseCase(this._repo);

  Stream<int> getIncomingOrders({
    required String porterId,
    required DateTime date,
  }) => _repo.getIncomingOrdersCount(porterId: porterId, date: date);

  Stream<int> getInProgressOrders({
    required String porterId,
    required DateTime date,
  }) => _repo.getInProgressOrdersCount(porterId: porterId, date: date);

  Stream<int> getCompletedOrders({
    required String porterId,
    required DateTime date,
  }) => _repo.getCompletedOrdersCount(porterId: porterId, date: date);

  Stream<double> getRevenue({
    required String porterId,
    required DateTime date,
  }) => _repo.getRevenue(porterId: porterId, date: date);
  
  Stream<double> getMonthlyRevenue({
    required String porterId,
    required DateTime month,
  }) => _repo.getMonthlyRevenue(porterId: porterId, month: month);
}

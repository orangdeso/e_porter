abstract class StatisticRepository {
  Stream<int> getIncomingOrdersCount({
    required String porterId,
    required DateTime date,
  });

  Stream<int> getInProgressOrdersCount({
    required String porterId,
    required DateTime date,
  });

  Stream<int> getCompletedOrdersCount({
    required String porterId,
    required DateTime date,
  });

  Stream<double> getRevenue({
    required String porterId,
    required DateTime date,
  });
}

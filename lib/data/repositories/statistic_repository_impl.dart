import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/domain/repositories/statistic_repository.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final FirebaseFirestore _firestore;
  StatisticRepositoryImpl(this._firestore);

  Timestamp _tsFromDate(DateTime d) =>
      Timestamp.fromDate(DateTime(d.year, d.month, d.day));
  Timestamp _tsToDate(DateTime d) =>
      Timestamp.fromDate(DateTime(d.year, d.month, d.day).add(const Duration(days: 1)));

  Query _baseQuery({
    required String porterId,
    required String status,
    required DateTime date,
  }) {
    return _firestore
        .collection('porterTransactions')
        .where('porterUserId', isEqualTo: porterId)
        .where('status', isEqualTo: status)
        .where('createdAt', isGreaterThanOrEqualTo: _tsFromDate(date))
        .where('createdAt', isLessThan: _tsToDate(date));
  }

  @override
  Stream<int> getIncomingOrdersCount({
    required String porterId,
    required DateTime date,
  }) {
    return _baseQuery(porterId: porterId, status: 'pending', date: date)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  @override
  Stream<int> getInProgressOrdersCount({
    required String porterId,
    required DateTime date,
  }) {
    return _baseQuery(porterId: porterId, status: 'proses', date: date)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  @override
  Stream<int> getCompletedOrdersCount({
    required String porterId,
    required DateTime date,
  }) {
    return _baseQuery(porterId: porterId, status: 'selesai', date: date)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  @override
  Stream<double> getRevenue({
    required String porterId,
    required DateTime date,
  }) {

    return _baseQuery(porterId: porterId, status: 'selesai', date: date)
        .snapshots()
        .asyncMap((snap) async {
      double total = 0;
      for (final doc in snap.docs) {
        final data = doc.data();
        final ticketId      = (data as Map<String, dynamic>?)?['ticketId'] ?? '';
        final transactionId = (data as Map<String, dynamic>?)?['transactionId'] ?? '';
        if (ticketId != null && transactionId != null) {
          // join ke sub‐collection payments
          final payDoc = await _firestore
              .collection('tickets')
              .doc(ticketId)
              .collection('payments')
              .doc(transactionId)
              .get();
          if (payDoc.exists && payDoc.data()!.containsKey('porterServiceDetails')) {
            final ps = payDoc['porterServiceDetails'] as Map<String, dynamic>;
            final a = (ps['arrival']['price']   as num).toDouble();
            final b = (ps['departure']['price'] as num).toDouble();
            total += a + b;
          }
        }
      }
      return total;
    });
  }
}

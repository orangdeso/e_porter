import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_porter/_core/service/logger_service.dart';

import '../../domain/models/ticket_model.dart';
import '../../domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final FirebaseFirestore firestore;

  TicketRepositoryImpl({required this.firestore});

  @override
  Future<List<TicketModel>> getTickets({
    required String from,
    required String to,
    required DateTime leavingDate,
  }) async {
    final collection = firestore.collection('tickets');

    // Normalisasi tanggal: ambil awal hari dan akhir hari untuk tanggal yang dicari
    final startOfDay = DateTime(leavingDate.year, leavingDate.month, leavingDate.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    logger.d(
        "Fetching tickets with parameters: from = $from, to = $to, leavingDate between = ${Timestamp.fromDate(startOfDay)} and ${Timestamp.fromDate(endOfDay)}");

    final snapshot = await collection
        .where('from', isEqualTo: from)
        .where('to', isEqualTo: to)
        .where('leavingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('leavingDate', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    logger.d("Number of tickets found: ${snapshot.docs.length}");
    snapshot.docs.forEach((doc) {
      logger.d("Doc ID: ${doc.id} => ${doc.data()}");
    });

    return snapshot.docs.map((doc) => TicketModel.fromDocument(doc)).toList();
  }

  @override
  Future<List<FlightModel>> getFlights({
    required String ticketId,
    required String flightClass,
  }) async {
    final subCollection = firestore.collection('tickets').doc(ticketId).collection('flights');

    Query query = subCollection;
    if (flightClass.isNotEmpty) {
      query = query.where('seatClass', isEqualTo: flightClass);
    }

    final snapshot = await query.get();
    logger.d("Number of flights found for ticket $ticketId with seatClass '$flightClass': ${snapshot.docs.length}");
    snapshot.docs.forEach((doc) {
      logger.d("Flight Doc ID: ${doc.id} => ${doc.data()}");
    });

    return snapshot.docs.map((doc) => FlightModel.fromDocument(doc)).toList();
  }

  @override
  Future<FlightModel> getFlightById({
    required String ticketId,
    required String flightId,
  }) async {
    final doc = await firestore
      .collection('tickets')
      .doc(ticketId)
      .collection('flights')
      .doc(flightId)
      .get();

  logger.d("getFlightById - TicketID: $ticketId, FlightID: $flightId, Data: ${doc.data()}");

  return FlightModel.fromDocument(doc);
  }
}

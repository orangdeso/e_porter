import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    String? seatClass,
  }) async {
    // final collection = firestore.collection('tickets');

    // final startOfDay = DateTime(leavingDate.year, leavingDate.month, leavingDate.day);
    // final endOfDay = startOfDay.add(Duration(days: 1));

    // final snapshot = await collection
    //     .where('from', isEqualTo: from)
    //     .where('to', isEqualTo: to)
    //     .where('leavingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
    //     .where('leavingDate', isLessThan: Timestamp.fromDate(endOfDay))
    //     .get();

    // snapshot.docs.forEach((doc) {});

    final startOfDay = DateTime(leavingDate.year, leavingDate.month, leavingDate.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    log("Fetching tickets: from=$from, to=$to, leavingDate∈[$startOfDay – $endOfDay]");

    final snapshot = await firestore
        .collection('tickets')
        .where('from', isEqualTo: from)
        .where('to', isEqualTo: to)
        .where('leavingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('leavingDate', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

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
    snapshot.docs.forEach((doc) {});

    return snapshot.docs.map((doc) => FlightModel.fromDocument(doc)).toList();
  }

  @override
  Future<FlightModel> getFlightById({
    required String ticketId,
    required String flightId,
  }) async {
    final doc = await firestore.collection('tickets').doc(ticketId).collection('flights').doc(flightId).get();

    // logger.d("getFlightById - TicketID: $ticketId, FlightID: $flightId, Data: ${doc.data()}");

    return FlightModel.fromDocument(doc);
  }
}

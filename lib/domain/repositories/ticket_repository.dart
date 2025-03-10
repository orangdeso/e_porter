import '../models/ticket_model.dart';

abstract class TicketRepository {
  Future<List<TicketModel>> getTickets({
    required String from,
    required String to,
    required DateTime leavingDate,
  });

  Future<List<FlightModel>> getFlights({
    required String ticketId,
    required String flightClass,
  });
}

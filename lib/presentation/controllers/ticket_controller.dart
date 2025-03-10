import 'package:e_porter/domain/repositories/ticket_repository.dart';
import 'package:get/get.dart';

import '../../domain/models/ticket_model.dart';
import '../../domain/usecases/ticket_usecase.dart';

class TicketController extends GetxController {
  final SearchFlightUseCase searchFlightUseCase;
  final TicketRepository ticketRepository;

  TicketController(this.searchFlightUseCase) : ticketRepository = searchFlightUseCase.repository;

  var tickets = <TicketModel>[].obs;
  var ticketFlight = <TicketFlightModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> searchTickets({
    required String from,
    required String to,
    required DateTime leavingDate,
    required String flightClass,
  }) async {
    try {
      isLoading.value = true;
      tickets.clear();
      ticketFlight.clear();

      final ticketList = await searchFlightUseCase(
        from: from,
        to: to,
        leavingDate: leavingDate,
      );
      tickets.addAll(ticketList);

      for (final t in ticketList) {
      final flights = await ticketRepository.getFlights(
        ticketId: t.id,
        flightClass: flightClass,
      );
      for (final f in flights) {
        ticketFlight.add(TicketFlightModel(ticket: t, flight: f));
      }
    }
    } catch (e) {
      errorMessage.value = e.toString();
      print("searchTickets error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

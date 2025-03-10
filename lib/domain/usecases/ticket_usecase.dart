import '../models/ticket_model.dart';
import '../repositories/ticket_repository.dart';

class SearchFlightUseCase {
  final TicketRepository repository;

  SearchFlightUseCase(this.repository);

  Future<List<TicketModel>> call({
    required String from,
    required String to,
    required DateTime leavingDate,
  }) {
    return repository.getTickets(
      from: from,
      to: to,
      leavingDate: leavingDate,
    );
  }
}
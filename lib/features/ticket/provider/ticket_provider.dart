import 'package:flutter_movie_booking_app/features/ticket/data/services/db_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/ticket.dart';

final ticketDbServiceProvider = Provider((ref) => DBService());

final ticketProvider =
    StateNotifierProvider<TicketNotifier, AsyncValue<List<Ticket>>>((ref) {
  final ticketService = ref.watch(ticketDbServiceProvider);
  return TicketNotifier(ticketService);
});

class TicketNotifier extends StateNotifier<AsyncValue<List<Ticket>>> {
  final DBService _ticketDbService;

  TicketNotifier(this._ticketDbService) : super(const AsyncValue.loading());

  Future<void> fetchTicket() async {
    try {
      state = const AsyncValue.loading();

      final movies = await _ticketDbService.getTicket();
      state = AsyncValue.data(movies);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> clearTicket() async {
    try {
      state = const AsyncValue.loading();

      await _ticketDbService.clearTickets();
      state = const AsyncValue.data([]);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

import 'dart:math';

import 'package:flutter_movie_booking_app/features/movie/data/models/movie.dart';
import 'package:flutter_movie_booking_app/features/ticket/data/services/db_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/models/ticket.dart';

// final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>(
//     (ref) => BookingNotifier());

final bookingProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  final ticketService = ref.watch(ticketDbServiceProvider);
  return BookingNotifier(ticketService);
});

final ticketDbServiceProvider = Provider((ref) => DBService());

class BookingState {
  final String? date;
  final String? time;
  final String? location;
  final Movie? movie;
  final List<String>? seats;
  final double moviePrice;

  const BookingState({
    this.date,
    this.time,
    this.location,
    this.movie,
    this.seats,
    this.moviePrice = 11.5,
  });

  BookingState copyWith({
    String? date,
    String? time,
    String? location,
    Movie? movie,
    List<String>? seats,
    double? moviePrice,
  }) {
    return BookingState(
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      movie: movie ?? this.movie,
      seats: seats ?? this.seats,
      moviePrice: moviePrice ?? this.moviePrice,
    );
  }

  String get formattedDate {
    if (date == null) return 'No date selected';
    final DateTime parsedDate = DateTime.parse(date!);
    return DateFormat('EEEE, dd MMMM yyyy').format(parsedDate);
  }

  String get getSeats {
    if (seats == null) return 'No seats selected';
    return seats!.join(', ');
  }

  int get getNumSeats => seats?.length ?? 0;
  double get getPriceSeats => getNumSeats * moviePrice;
  bool get canSelectSeats =>
      movie != null && location != null && time != null && date != null;
}

class BookingNotifier extends StateNotifier<BookingState> {
  final DBService _ticketDbService;
  BookingNotifier(this._ticketDbService) : super(const BookingState());

  void updateBooking({
    String? date,
    String? time,
    String? location,
    Movie? movie,
  }) {
    state = state.copyWith(
      date: date,
      time: time,
      location: location,
      movie: movie,
    );
  }

  void selectSeats(List<String> seats) {
    state = state.copyWith(seats: seats);
  }

  void addTicket() {
    state.seats?.forEach((seat) {
      _ticketDbService.insertTicket(Ticket.fromMap({
        'movie_name': state.movie?.title ?? '',
        'movie_poster': state.movie?.posterPath ?? '',
        'movie_backdrop': state.movie?.backdropPath ?? '',
        'movie_duration': 124,
        'location': state.location,
        'date': state.date,
        'time': state.time,
        'seat': seat, // Insert seat dynamically
        'room_number': '10',
        'trx_id': _generateRandomString(18),
      }));
    });
  }

  String _generateRandomString(int length) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }
}

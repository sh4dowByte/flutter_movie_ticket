import 'package:flutter_movie_booking_app/features/movie/data/models/movie.dart';
import 'package:flutter_movie_booking_app/features/ticket/data/services/db_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>(
    (ref) => BookingNotifier());
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
  bool get canSelectSeats => location != null && time != null && date != null;
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(const BookingState());

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

  // void addTicket() {
  //   ticketDbServiceProvider.
  // }
}

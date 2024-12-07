import 'package:intl/intl.dart';

class Ticket {
  final String movieName;
  final String moviePoster;
  final String movieBackdrop;
  final int movieDuration;
  final String location;
  final String date;
  final String time;
  final String seat;
  final String roomNumber;
  final String trxId;

  Ticket({
    required this.movieName,
    required this.moviePoster,
    required this.movieBackdrop,
    required this.movieDuration,
    required this.location,
    required this.date,
    required this.time,
    required this.seat,
    required this.roomNumber,
    required this.trxId,
  });

  String get seatLetter => seat.replaceAll(RegExp(r'\d'), '');
  String get seatNumber => seat.replaceAll(RegExp(r'\D'), '');

  String get time12 =>
      DateFormat("hh:mm a").format(DateFormat("HH.mm").parse(time));

  String get formattedDate =>
      DateFormat('EEE, MMM dd').format(DateTime.parse(date));

  String get getDayFromDate => DateFormat('EEEE').format(DateTime.parse(date));

  String get durationHour => '${movieDuration ~/ 60}h ${movieDuration % 60}min';

  // Factory method for creating a Ticket instance from a Map
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      movieName: map['movie_name'] ?? '',
      moviePoster: map['movie_poster'] ?? '',
      movieBackdrop: map['movie_backdrop'] ?? '',
      movieDuration: map['movie_duration'] ?? 0,
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      seat: map['seat'] ?? '',
      roomNumber: map['room_number'] ?? '',
      trxId: map['trx_id'] ?? '',
    );
  }

  // Convert a Ticket instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'movie_name': movieName,
      'movie_poster': moviePoster,
      'movie_backdrop': movieBackdrop,
      'movie_duration': movieDuration,
      'location': location,
      'date': date,
      'time': time,
      'seat': seat,
      'room_number': roomNumber,
      'trx_id': trxId,
    };
  }
}

extension MovieImageUrl on Ticket {
  String _getImageUrl(String size, {bool isBackdrop = false}) {
    return moviePoster.isNotEmpty
        ? 'https://image.tmdb.org/t/p/$size$moviePoster'
        : 'https://img.icons8.com/?size=480&id=gX6VczTLnV3E&format=png';
  }

  String get backdropUrlOriginal => _getImageUrl('original', isBackdrop: true);
  String get backdropUrlW500 => _getImageUrl('w500', isBackdrop: true);
  String get backdropUrlW300 => _getImageUrl('w300', isBackdrop: true);
  String get imageUrlOriginal => _getImageUrl('original');
  String get imageUrlW500 => _getImageUrl('w500');
  String get imageUrlW300 => _getImageUrl('w300');
  String get imageUrlW200 => _getImageUrl('w200');
}

import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/core/pallete.dart';
import 'package:flutter_movie_booking_app/core/routes.dart';
import 'package:flutter_movie_booking_app/features/movie/presentation/widgets/app_movie_card.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_now_playing.dart';
import 'package:flutter_movie_booking_app/features/ticket/presentation/widgets/app_select_time.dart';
import 'package:flutter_movie_booking_app/widget/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/booking_provider.dart';
import '../widgets/app_select_date.dart';

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(nowPlayingMoviesProvider);
    final bookingNotifier = ref.watch(bookingProvider.notifier);
    final bookingState = ref.watch(bookingProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Membuat AppBar transparan
        elevation: 0, // Menghilangkan bayangan
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Pallete.black1,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return ChoseLocationComponent(
                        onSelect: (location) {
                          bookingNotifier.updateBooking(location: location);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF131313),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  // margin: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 8),
                      Text(bookingState.location ?? 'Chose your location'),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Now Playing
          movieState.when(
            loading: () => AppMovieCoverBox.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (data) => SizedBox(
              height: 500,
              child: AppImageSliderManual(
                onChange: (movie) {
                  bookingNotifier.updateBooking(movie: movie);
                },
                data: data.map((movie) => movie).take(10).toList(),
              ),
            ),
          ),

          // Select date
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 11),
            child: Text('Select the date'),
          ),
          const SizedBox(height: 16),

          AppSelectDate(
            item: const [
              '2024-10-10',
              '2024-10-11',
              '2024-10-12',
              '2024-10-13',
              '2024-10-14',
              '2024-10-15',
              '2024-10-16',
              '2024-10-17',
              '2024-10-18',
              '2024-10-19',
            ],
            onChange: (date) {
              bookingNotifier.updateBooking(date: date);
            },
          ),

          // Select time
          const SizedBox(height: 20),
          AppSelectTime(
            item: const [
              '11.00',
              '12.00',
              '13.00',
              '14.00',
              '15.00',
              '16.00',
              '17.00',
              '18.00',
              '19.00',
            ],
            onChange: (time) {
              bookingNotifier.updateBooking(time: time);
            },
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppButton(
              color: !bookingState.canSelectSeats ? Colors.grey : Pallete.blue1,
              text: 'Go to select seats',
              onTap: () {
                if (bookingState.canSelectSeats) {
                  Navigator.pushNamed(context, Routes.seats);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChoseLocationComponent extends StatelessWidget {
  final Function(String)? onSelect;
  const ChoseLocationComponent({
    super.key,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10, // Jumlah skeleton placeholder
        itemBuilder: (context, index) {
          String location = 'Aventura';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: InkWell(
              onTap: () {
                if (onSelect != null) {
                  onSelect!(location);
                }
              },
              hoverColor: Colors.transparent,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(location),
                      Text(
                        'Banjarbaru, 36 Km',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

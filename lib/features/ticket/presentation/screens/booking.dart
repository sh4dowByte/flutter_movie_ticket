import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_now_playing.dart';
import 'package:flutter_movie_booking_app/features/ticket/presentation/widgets/app_select_time.dart';
import 'package:flutter_movie_booking_app/widget/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/app_select_date.dart';

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(nowPlayingMoviesProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Membuat AppBar transparan
        elevation: 0, // Menghilangkan bayangan
        actions: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xFF131313),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(right: 16),
            child: const Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 8),
                Text('Aventura 24'),
                SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.green,
                )
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Now Playing
          movieState.when(
            loading: () => AppSelectItemSmall.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (data) => SizedBox(
              height: 500,
              child: AppImageSliderManual(
                data: data
                    .map((movie) => {
                          'title': movie.title,
                          'image':
                              'https://image.tmdb.org/t/p/w1280${movie.posterPath}'
                        })
                    .take(10)
                    .toList(),
              ),
            ),
          ),

          // Select date
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 11),
            child: Text('Select the date'),
          ),
          const SizedBox(height: 16),

          const AppSelectDate(
            item: [
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
          ),

          // Select time
          const SizedBox(height: 20),
          const AppSelectTime(item: [
            '11.00',
            '12.00',
            '13.00',
            '14.00',
            '15.00',
            '16.00',
            '17.00',
            '18.00',
            '19.00',
          ]),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: AppButton(
              text: 'Go to select seats',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/widget/app_select_time.dart';
import 'package:flutter_movie_booking_app/widget/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/movie_provider.dart';
import '../widget/app_select_date.dart';

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieProvider);

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent, // Membuat AppBar transparan
      //   elevation: 0, // Menghilangkan bayangan
      //   title: const Text('Transparent AppBar'),
      // ),
      body: ListView(
        children: [
          // Now Playing
          movieState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : movieState.error != null
                  ? Center(child: Text('Error: ${movieState.error}'))
                  : SizedBox(
                      height: 500,
                      child: AppImageSliderManual(
                        data: movieState.nowPlayingMovies
                            .map((movie) => {
                                  'title': movie.title,
                                  'image':
                                      'https://image.tmdb.org/t/p/w1280${movie.posterPath}'
                                })
                            .take(10)
                            .toList(),
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

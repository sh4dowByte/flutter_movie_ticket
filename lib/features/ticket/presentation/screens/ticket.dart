import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../movie/providers/movie_now_playing.dart';
import '../widgets/app_ticket_card.dart';
import '../widgets/infinite_dragable_slider.dart';

class TicketPage extends ConsumerWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieStateNowPlaying = ref.watch(nowPlayingMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).copyWith(right: 50),
        child: movieStateNowPlaying.when(
          loading: () => const Text('Loading'),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (data) => Center(
            child: SizedBox(
              height: 500,
              child: InfiniteDragableSlider(
                iteamCount: data.length,
                itemBuilder: (context, index) => SizedBox(
                  child: AppTicketCard(data: data[index]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

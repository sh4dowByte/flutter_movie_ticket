import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/widget/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/movie_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(movieProvider.notifier).fetchPopularMovies();
              ref.read(movieProvider.notifier).fetchNowPlayingMovies();
              ref.read(movieProvider.notifier).fetchRecommendedMovies(1106739);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Now Playing
          movieState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : movieState.error != null
                  ? Center(child: Text('Error: ${movieState.error}'))
                  : SizedBox(
                      height: 362,
                      child: AppImageSlider(
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

          const SizedBox(height: 20),
          // Search
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 11),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF272727).withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Color(0xFFD9D9D9),
                ),
                SizedBox(width: 18),
                Text(
                  'Search...',
                  style: TextStyle(
                    color: Color(0xFFD9D9D9),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 23),

          // Categories
          const AppSelectItemSmall(item: [
            {'id': 1, 'name': 'All'},
            {'id': 2, 'name': 'Action'},
            {'id': 3, 'name': 'Adventure'},
            {'id': 4, 'name': 'Horror'},
            {'id': 5, 'name': 'All'},
            {'id': 6, 'name': 'Action'},
            {'id': 7, 'name': 'Adventure'},
            {'id': 8, 'name': 'Horror'},
          ]),

          const SizedBox(height: 23),

          // popular
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Discover'), Text('See More')],
            ),
          ),
          const SizedBox(
            height: 16,
          ),

          movieState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : movieState.error != null
                  ? Center(child: Text('Error: ${movieState.error}'))
                  : SizedBox(
                      height: 220,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: movieState.popularMovies.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final item = movieState.popularMovies[index];

                            EdgeInsets margin = EdgeInsets.only(
                              left: index == 0 ? 11 : 4,
                              right:
                                  index == movieState.popularMovies.length - 1
                                      ? 11
                                      : 4,
                            );

                            return Container(
                              margin: margin,
                              key: PageStorageKey(index),
                              width: 162,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w1280${item.posterPath}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                    ),

          const SizedBox(height: 23),

          // popular
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Popular Movies'), Text('See More')],
            ),
          ),
          const SizedBox(
            height: 16,
          ),

          movieState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : movieState.error != null
                  ? Center(child: Text('Error: ${movieState.error}'))
                  : SizedBox(
                      height: 220,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: movieState.popularMovies.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final item = movieState.popularMovies[index];

                            EdgeInsets margin = EdgeInsets.only(
                              left: index == 0 ? 11 : 4,
                              right:
                                  index == movieState.popularMovies.length - 1
                                      ? 11
                                      : 4,
                            );

                            return Container(
                              margin: margin,
                              key: PageStorageKey(index),
                              width: 162,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w1280${item.posterPath}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                    ),
        ],
      ),
    );
  }
}

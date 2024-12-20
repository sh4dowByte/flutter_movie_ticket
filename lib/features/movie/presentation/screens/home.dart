import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/genres_provider.dart';
import 'package:flutter_movie_booking_app/features/movie/presentation/widgets/app_movie_card.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_discover_provider.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_now_playing.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_popular_provider.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_top_rated_provider.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_upcoming_provider.dart';
import 'package:flutter_movie_booking_app/widget/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollControllerDiscover = ScrollController();
  final ScrollController _scrollControllerPopular = ScrollController();
  final ScrollController _scrollControllerTopRated = ScrollController();
  final ScrollController _scrollControllerUpcoming = ScrollController();
  int genreId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nowPlayingMoviesProvider.notifier).fetchNowPlayingMovies();
      ref.read(genresProvider.notifier).fetchGenres();
      ref.read(discoverMoviesProvider.notifier).fetchDiscoverMovies(genreId);
      ref.read(popularMoviesProvider.notifier).fetchPopularMovies();
      ref.read(topRatedMoviesProvider.notifier).fetchTopRatedMovies();
      ref.read(upcomingMoviesProvider.notifier).fetchUpcomingMovies();
    });

    _scrollControllerDiscover.addListener(() {
      if (_scrollControllerDiscover.position.pixels >=
          _scrollControllerDiscover.position.maxScrollExtent) {
        ref.read(discoverMoviesProvider.notifier).fetchDiscoverMovies(genreId);
      }
    });

    _scrollControllerPopular.addListener(() {
      if (_scrollControllerPopular.position.pixels >=
          _scrollControllerPopular.position.maxScrollExtent) {
        ref.read(popularMoviesProvider.notifier).fetchPopularMovies();
      }
    });

    _scrollControllerTopRated.addListener(() {
      if (_scrollControllerTopRated.position.pixels >=
          _scrollControllerTopRated.position.maxScrollExtent) {
        ref.read(topRatedMoviesProvider.notifier).fetchTopRatedMovies();
      }
    });

    _scrollControllerUpcoming.addListener(() {
      if (_scrollControllerUpcoming.position.pixels >=
          _scrollControllerUpcoming.position.maxScrollExtent) {
        ref.read(upcomingMoviesProvider.notifier).fetchUpcomingMovies();
      }
    });
  }

  @override
  void dispose() {
    _scrollControllerDiscover.dispose();
    _scrollControllerPopular.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieStateNowPlaying = ref.watch(nowPlayingMoviesProvider);
    final movieStatePopular = ref.watch(popularMoviesProvider);
    final genresState = ref.watch(genresProvider);
    final discoverMovieState = ref.watch(discoverMoviesProvider);
    final topRatedMovieState = ref.watch(topRatedMoviesProvider);
    final upcomingMovieState = ref.watch(upcomingMoviesProvider);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          // Now Playing
          movieStateNowPlaying.when(
            loading: () => AppImageSlider.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (data) => SizedBox(
              height: 362,
              child: AppImageSlider(
                movie: data.take(14).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),
          // Search
          InkWell(
            hoverColor: Colors.transparent, // Hapus efek hover
            onTap: () => Navigator.pushNamed(context, Routes.movieSearch),
            child: Container(
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
          ),

          const SizedBox(height: 23),

          // Genres
          genresState.when(
            loading: () => AppSelectItemSmall.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (data) => AppSelectItemSmall(
              onChange: (id) {
                ref
                    .read(discoverMoviesProvider.notifier)
                    .fetchDiscoverMovies(id);

                genreId = id;
              },
              item: [
                const {
                  'id': 0,
                  'name': 'All',
                },
                ...data.map((e) => e.toJson())
              ],
            ),
          ),

          const SizedBox(height: 23),

          // Discover
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discover'),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.seeMore,
                      arguments: {
                        'title': 'Discover',
                        'genreId': genreId,
                        'providerKey': 'discover'
                      }),
                  child: Text(
                    'See More',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),

          discoverMovieState.when(
            data: (data) => SizedBox(
              height: 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollControllerDiscover,
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    EdgeInsets margin = EdgeInsets.only(
                      left: index == 0 ? 11 : 4,
                      right: index == data.length - 1 ? 11 : 4,
                    );

                    return AppMovieCoverBox(item: item, margin: margin);
                  }),
            ),
            loading: () => AppMovieCoverBox.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),

          const SizedBox(height: 23),

          // Popular
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Popular Movies'),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.seeMore,
                      arguments: {
                        'title': 'Popular Movies',
                        'providerKey': 'popular'
                      }),
                  child: Text(
                    'See More',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),

          movieStatePopular.when(
            data: (data) => SizedBox(
              height: 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollControllerPopular,
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    EdgeInsets margin = EdgeInsets.only(
                      left: index == 0 ? 11 : 4,
                      right: index == data.length - 1 ? 11 : 4,
                    );

                    return AppMovieCoverBox(item: item, margin: margin);
                  }),
            ),
            loading: () => AppMovieCoverBox.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),

          const SizedBox(height: 23),

          // Top Rated
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Top Rated Movies'),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.seeMore,
                      arguments: {
                        'title': 'Top Rated Movies',
                        'providerKey': 'top_rated'
                      }),
                  child: Text(
                    'See More',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),

          topRatedMovieState.when(
            data: (data) => SizedBox(
              height: 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollControllerTopRated,
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    EdgeInsets margin = EdgeInsets.only(
                      left: index == 0 ? 11 : 4,
                      right: index == data.length - 1 ? 11 : 4,
                    );

                    return AppMovieCoverBox(item: item, margin: margin);
                  }),
            ),
            loading: () => AppMovieCoverBox.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),

          const SizedBox(height: 23),

          // Upcoming
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Upcoming Movies'),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.seeMore,
                      arguments: {
                        'title': 'Upcoming Movies',
                        'providerKey': 'upcoming'
                      }),
                  child: Text(
                    'See More',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),

          upcomingMovieState.when(
            data: (data) => SizedBox(
              height: 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollControllerUpcoming,
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    EdgeInsets margin = EdgeInsets.only(
                      left: index == 0 ? 11 : 4,
                      right: index == data.length - 1 ? 11 : 4,
                    );

                    return AppMovieCoverBox(item: item, margin: margin);
                  }),
            ),
            loading: () => AppMovieCoverBox.loading(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/genres_provider.dart';
import 'package:flutter_movie_booking_app/features/movie/presentation/widgets/app_movie_card.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_discover_provider.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_now_playing.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_popular_provider.dart';
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
  int genreId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nowPlayingMoviesProvider.notifier).fetchNowPlayingMovies();
      ref.read(popularMoviesProvider.notifier).fetchPopularMovies();
      ref.read(genresProvider.notifier).fetchGenres();
      ref.read(discoverMoviesProvider.notifier).fetchDiscoverMovies(genreId);
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Popular Movies'), Text('See More')],
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
          )
        ],
      ),
    );
  }
}

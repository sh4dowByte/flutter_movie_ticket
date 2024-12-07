import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/movie/presentation/widgets/app_movie_card.dart';
import 'package:flutter_movie_booking_app/features/movie/providers/movie_search_provider.dart';
import 'package:flutter_movie_booking_app/widget/app_error.dart';
import 'package:flutter_movie_booking_app/widget/app_text_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieSearchPage extends ConsumerStatefulWidget {
  const MovieSearchPage({super.key});

  @override
  ConsumerState<MovieSearchPage> createState() => MovieSearchPageState();
}

class MovieSearchPageState extends ConsumerState<MovieSearchPage> {
  final ScrollController _scrollControllerSearch = ScrollController();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchMoviesProvider.notifier).resetSearch();
    });

    _scrollControllerSearch.addListener(() {
      if (_scrollControllerSearch.position.pixels >=
          _scrollControllerSearch.position.maxScrollExtent) {
        ref.read(searchMoviesProvider.notifier).searchMovie(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _scrollControllerSearch.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchMovieState = ref.watch(searchMoviesProvider);

    return Scaffold(
      appBar: AppBar(
          title: // Search
              AppTextSearch(
        controller: _controller,
        onSubmitted: (text) {
          ref.read(searchMoviesProvider.notifier).searchMovie(text);
        },
      )),
      body: searchMovieState.when(
        data: (data) {
          return SizedBox(
            child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollControllerSearch,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return AppMovieCoverTile(item: item);
                }),
          );
        },
        loading: () => AppMovieCoverTile.loading(),
        error: (error, stackTrace) => AppError(
          error,
          stackTrace: stackTrace,
        ),
      ),
    );
  }
}

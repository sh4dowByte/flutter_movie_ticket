import 'package:flutter_movie_booking_app/models/movie_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class MovieDetailState {
  final MovieDetail? movie;
  final bool isLoading;
  final String? error;

  MovieDetailState({
    required this.movie,
    required this.isLoading,
    this.error,
  });

  factory MovieDetailState.initial() {
    return MovieDetailState(
      movie: null,
      isLoading: false,
      error: null,
    );
  }

  MovieDetailState copyWith({
    MovieDetail? movie,
    bool? isLoading,
    String? error,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MovieDetailNotifier extends StateNotifier<MovieDetailState> {
  final MovieService _movieService;

  MovieDetailNotifier(this._movieService) : super(MovieDetailState.initial());

  Future<void> fetchMovieDetails(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchMovieDetails(id);
      state = state.copyWith(movie: movies, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final movieDetailProvider =
    StateNotifierProvider<MovieDetailNotifier, MovieDetailState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieDetailNotifier(movieService);
});

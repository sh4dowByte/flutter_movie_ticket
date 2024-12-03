import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class MovieState {
  final List<Movie> popularMovies;
  final List<Movie> recommendedMovies;
  final List<Movie> nowPlayingMovies;
  final bool isLoading;
  final String? error;

  MovieState({
    required this.popularMovies,
    required this.recommendedMovies,
    required this.nowPlayingMovies,
    required this.isLoading,
    this.error,
  });

  factory MovieState.initial() {
    return MovieState(
      popularMovies: [],
      recommendedMovies: [],
      nowPlayingMovies: [],
      isLoading: false,
      error: null,
    );
  }

  MovieState copyWith({
    List<Movie>? popularMovies,
    List<Movie>? recommendedMovies,
    List<Movie>? nowPlayingMovies,
    bool? isLoading,
    String? error,
  }) {
    return MovieState(
      popularMovies: popularMovies ?? this.popularMovies,
      recommendedMovies: recommendedMovies ?? this.recommendedMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MovieNotifier extends StateNotifier<MovieState> {
  final MovieService _movieService;

  MovieNotifier(this._movieService) : super(MovieState.initial());

  Future<void> fetchPopularMovies() async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchPopularMovies();
      state =
          state.copyWith(popularMovies: movies, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchNowPlayingMovies() async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchNowPlayingMovies();
      state = state.copyWith(
          nowPlayingMovies: movies, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchRecommendedMovies(int movieId) async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchRecommendedMovies(movieId);
      state = state.copyWith(
          recommendedMovies: movies, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final movieProvider = StateNotifierProvider<MovieNotifier, MovieState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieNotifier(movieService);
});

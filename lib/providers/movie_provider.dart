import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class MovieCategoryState {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;

  MovieCategoryState({
    required this.movies,
    required this.isLoading,
    this.error,
  });

  factory MovieCategoryState.initial() {
    return MovieCategoryState(
      movies: [],
      isLoading: false,
      error: null,
    );
  }

  MovieCategoryState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? error,
  }) {
    return MovieCategoryState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PopularMoviesNotifier extends StateNotifier<MovieCategoryState> {
  PopularMoviesNotifier(this._movieService)
      : super(MovieCategoryState.initial());

  final MovieService _movieService;
  int _currentPage = 1; // Halaman saat ini
  bool _isFetching = false;

  Future<void> fetchPopularMovies() async {
    if (_isFetching) return; // Hindari memuat ulang jika sudah loading

    _isFetching = true;

    try {
      print('popular $_currentPage');
      final newMovies = await _movieService.fetchPopularMovies(_currentPage);
      _currentPage++;

      state = state.copyWith(
        movies: [...state.movies, ...newMovies],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    } finally {
      _isFetching = false;
    }
  }
}

class DiscoverMoviesNotifier extends StateNotifier<MovieCategoryState> {
  DiscoverMoviesNotifier(this._movieService)
      : super(MovieCategoryState.initial());

  final MovieService _movieService;
  int _currentPage = 1; // Halaman saat ini
  bool _isFetching = false;
  int _lastGenre = 0;

  Future<void> fetchDiscoverMovies(int genresId) async {
    if (_isFetching) return; // Hindari memuat ulang jika sudah loading

    _isFetching = true;

    if (_lastGenre != genresId) {
      _currentPage = 1;
      state = state.copyWith(
        movies: [],
        isLoading: false,
        error: null,
      );
    }

    if (_currentPage == 1) {
      state = state.copyWith(isLoading: true);
    }

    _lastGenre = genresId;

    try {
      final newMovies = await _movieService.fetchDiscover(
          page: _currentPage, genres: genresId);
      _currentPage++;

      state = state.copyWith(
        movies: [...state.movies, ...newMovies],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    } finally {
      _isFetching = false;
    }
  }
}

class NowPlayingMoviesNotifier extends StateNotifier<MovieCategoryState> {
  final MovieService _movieService;

  NowPlayingMoviesNotifier(this._movieService)
      : super(MovieCategoryState.initial());

  Future<void> fetchNowPlayingMovies() async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchNowPlayingMovies();
      state = state.copyWith(movies: movies, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class RecommendedMoviesNotifier extends StateNotifier<MovieCategoryState> {
  final MovieService _movieService;

  RecommendedMoviesNotifier(this._movieService)
      : super(MovieCategoryState.initial());

  Future<void> fetchRecommendedMovies(int movieId) async {
    state = state.copyWith(isLoading: true);
    try {
      final movies = await _movieService.fetchRecommendedMovies(movieId);
      state = state.copyWith(movies: movies, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final nowPlayingMoviesProvider =
    StateNotifierProvider<NowPlayingMoviesNotifier, MovieCategoryState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return NowPlayingMoviesNotifier(movieService);
});

final discoverMoviesProvider =
    StateNotifierProvider<DiscoverMoviesNotifier, MovieCategoryState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return DiscoverMoviesNotifier(movieService);
});

final popularMoviesProvider =
    StateNotifierProvider<PopularMoviesNotifier, MovieCategoryState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return PopularMoviesNotifier(movieService);
});

final recomendedMoviesProvider =
    StateNotifierProvider<RecommendedMoviesNotifier, MovieCategoryState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return RecommendedMoviesNotifier(movieService);
});

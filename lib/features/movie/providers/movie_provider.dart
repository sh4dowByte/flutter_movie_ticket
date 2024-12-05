import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class PopularMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  PopularMoviesNotifier(this._movieService) : super(const AsyncValue.loading());

  final MovieService _movieService;
  int _currentPage = 1; // Halaman saat ini
  bool _isFetching = false;

  Future<void> fetchPopularMovies() async {
    if (_isFetching) return; // Hindari memuat ulang jika sudah loading

    _isFetching = true;

    try {
      final newMovies = await _movieService.fetchPopularMovies(_currentPage);
      _currentPage++;

      state = AsyncValue.data([
        ...(state.value ??
            []), // Menggabungkan data sebelumnya dengan data baru
        ...newMovies,
      ]);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    } finally {
      _isFetching = false;
    }
  }
}

class DiscoverMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  DiscoverMoviesNotifier(this._movieService)
      : super(const AsyncValue.loading());

  final MovieService _movieService;
  int _currentPage = 1; // Halaman saat ini
  bool _isFetching = false;
  int _lastGenre = 0;

  Future<void> fetchDiscoverMovies(int genresId) async {
    if (_isFetching) return; // Hindari memuat ulang jika sudah loading

    _isFetching = true;

    if (_lastGenre != genresId) {
      _currentPage = 1;
      state = const AsyncValue.loading(); // Reset loading state
    }

    _lastGenre = genresId;

    try {
      final newMovies = await _movieService.fetchDiscover(
        page: _currentPage,
        genres: genresId,
      );
      _currentPage++;

      state = AsyncValue.data([
        ...(state.value ??
            []), // Menggabungkan data sebelumnya dengan data baru
        ...newMovies,
      ]);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    } finally {
      _isFetching = false;
    }
  }
}

class NowPlayingMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieService _movieService;

  NowPlayingMoviesNotifier(this._movieService)
      : super(const AsyncValue.loading());

  Future<void> fetchNowPlayingMovies() async {
    try {
      final movies = await _movieService.fetchNowPlayingMovies();
      state = AsyncValue.data(movies);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

class RecommendedMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieService _movieService;

  RecommendedMoviesNotifier(this._movieService)
      : super(const AsyncValue.loading());

  Future<void> fetchRecommendedMovies(int movieId) async {
    try {
      final movies = await _movieService.fetchRecommendedMovies(movieId);
      state = AsyncValue.data(movies);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final nowPlayingMoviesProvider =
    StateNotifierProvider<NowPlayingMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return NowPlayingMoviesNotifier(movieService);
});

final discoverMoviesProvider =
    StateNotifierProvider<DiscoverMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return DiscoverMoviesNotifier(movieService);
});

final popularMoviesProvider =
    StateNotifierProvider<PopularMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return PopularMoviesNotifier(movieService);
});

final recomendedMoviesProvider =
    StateNotifierProvider<RecommendedMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return RecommendedMoviesNotifier(movieService);
});

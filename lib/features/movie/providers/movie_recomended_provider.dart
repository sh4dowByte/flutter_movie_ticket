import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class RecommendedMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieService _movieService;
  int _currentPage = 1; // Halaman saat ini
  bool _isFetching = false;
  bool _isEnd = false;

  RecommendedMoviesNotifier(this._movieService)
      : super(const AsyncValue.loading());

  Future<void> fetchRecommendedMovies(int movieId, {isInit = false}) async {
    if (isInit) {
      _isEnd = false;
      _currentPage = 1;
      state = const AsyncValue.data([]);
    }

    if (_isFetching) return; // Hindari memuat ulang jika sudah loading
    if (_isEnd) return;

    _isFetching = true;

    try {
      final newMovies = await _movieService.fetchRecommendedMovies(movieId,
          page: _currentPage);
      _currentPage++;

      if (newMovies.isEmpty) _isEnd = true;

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

// class RecommendedMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
//   RecommendedMoviesNotifier(this._movieService)
//       : super(const AsyncValue.loading());

//   final MovieService _movieService;
//   int _currentPage = 1; // Halaman saat ini
//   bool _isFetching = false;
//   bool _isEnd = false;

//   Future<void> fetchRecommendedMovies(int movieId, {isInit = false}) async {
//     if (isInit) {
//       _isEnd = false;
//       _currentPage = 1;
//     }

//     if (_isFetching) return; // Hindari memuat ulang jika sudah loading
//     if (_isEnd) return;

//     _isFetching = true;

//     try {
//       print('fetch $_currentPage');
//       final newMovies = await _movieService.fetchRecommendedMovies(movieId,
//           page: _currentPage);
//       _currentPage++;

//       if (newMovies.isEmpty) _isEnd = true;

//       state = AsyncValue.data([
//         ...(state.value ??
//             []), // Menggabungkan data sebelumnya dengan data baru
//         ...newMovies,
//       ]);
//     } catch (e, s) {
//       state = AsyncValue.error(e, s);
//     } finally {
//       _isFetching = false;
//     }
//   }
// }

final recomendedMoviesProvider =
    StateNotifierProvider<RecommendedMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return RecommendedMoviesNotifier(movieService);
});

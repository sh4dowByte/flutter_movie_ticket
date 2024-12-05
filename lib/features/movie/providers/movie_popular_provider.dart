import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final popularMoviesProvider =
    StateNotifierProvider<PopularMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return PopularMoviesNotifier(movieService);
});

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

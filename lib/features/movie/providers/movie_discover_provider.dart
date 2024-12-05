import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final discoverMoviesProvider =
    StateNotifierProvider<DiscoverMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return DiscoverMoviesNotifier(movieService);
});

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

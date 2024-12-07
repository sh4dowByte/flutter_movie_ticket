import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, AsyncValue<List<Movie>>>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return SearchMoviesNotifier(movieService);
});

class SearchMoviesNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  SearchMoviesNotifier(this._movieService) : super(const AsyncValue.loading());

  final MovieService _movieService;
  int _currentPage = 1; // Halaman saat ini
  bool _isFetching = false;
  String _keyword = '';

  Future<void> searchMovie(String keyword) async {
    if (_isFetching) return; // Hindari memuat ulang jika sudah loading
    if (_keyword != keyword) {
      _currentPage = 1;
      state = const AsyncValue.loading(); // Reset loading state
    }
    _keyword = keyword;
    _isFetching = true;

    try {
      final newMovies =
          await _movieService.searchMovies(keyword, page: _currentPage);
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

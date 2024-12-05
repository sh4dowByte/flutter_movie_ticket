import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

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

final recomendedMoviesProvider =
    StateNotifierProvider<RecommendedMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return RecommendedMoviesNotifier(movieService);
});

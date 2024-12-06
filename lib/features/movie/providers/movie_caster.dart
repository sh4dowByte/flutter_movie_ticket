import 'package:flutter_movie_booking_app/features/movie/data/models/cast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final movieCasterProvider =
    StateNotifierProvider<MovieCasterNotifier, AsyncValue<List<Cast>>>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieCasterNotifier(movieService);
});

class MovieCasterNotifier extends StateNotifier<AsyncValue<List<Cast>>> {
  final MovieService _movieService;

  MovieCasterNotifier(this._movieService) : super(const AsyncValue.loading());

  Future<void> fetchMovieCaster(int movieId) async {
    try {
      final movies = await _movieService.fetchMovieCaster(movieId);
      state = AsyncValue.data(movies);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

import 'package:flutter_movie_booking_app/features/movie/data/models/movie_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/movie_services.dart';

// MovieService Provider
final movieServiceProvider = Provider((ref) => MovieService());

// Menggunakan AsyncValue untuk MovieDetail
final movieDetailProvider =
    StateNotifierProvider<MovieDetailNotifier, AsyncValue<MovieDetail>>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieDetailNotifier(movieService);
});

// Notifier untuk MovieDetail
class MovieDetailNotifier extends StateNotifier<AsyncValue<MovieDetail>> {
  final MovieService _movieService;

  MovieDetailNotifier(this._movieService) : super(const AsyncValue.loading());

  Future<void> fetchMovieDetails(int id) async {
    try {
      state = const AsyncValue.loading();
      final movie = await _movieService.fetchMovieDetails(id);
      state = AsyncValue.data(movie);
    } catch (e, stackTrace) {
      // Memberikan error dan stackTrace
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

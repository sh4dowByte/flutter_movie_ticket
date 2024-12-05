import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final nowPlayingMoviesProvider =
    StateNotifierProvider<NowPlayingMoviesNotifier, AsyncValue<List<Movie>>>(
        (ref) {
  final movieService = ref.watch(movieServiceProvider);
  return NowPlayingMoviesNotifier(movieService);
});

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

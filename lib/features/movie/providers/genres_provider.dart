import 'package:flutter_movie_booking_app/features/movie/data/models/genres.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class GenresNotifier extends StateNotifier<AsyncValue<List<Genres>>> {
  final MovieService _movieService;

  GenresNotifier(this._movieService) : super(const AsyncValue.loading());

  Future<void> fetchGenres() async {
    try {
      // Update state menjadi loading sebelum data diambil
      state = const AsyncValue.loading();

      // Mengambil data genres
      final data = await _movieService.fetchGenres();

      // Mengupdate state menjadi data setelah sukses
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      // Memberikan error dan stackTrace
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final genresProvider =
    StateNotifierProvider<GenresNotifier, AsyncValue<List<Genres>>>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return GenresNotifier(movieService);
});

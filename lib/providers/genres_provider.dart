import 'package:flutter_movie_booking_app/models/genres.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/movie_services.dart';

final movieServiceProvider = Provider((ref) => MovieService());

class GenresState {
  final List<Genres> genres;
  final bool isLoading;
  final String? error;

  GenresState({
    required this.genres,
    required this.isLoading,
    this.error,
  });

  factory GenresState.initial() {
    return GenresState(
      genres: [],
      isLoading: false,
      error: null,
    );
  }

  GenresState copyWith({
    List<Genres>? genres,
    bool? isLoading,
    String? error,
  }) {
    return GenresState(
      genres: genres ?? this.genres,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class GenresNotifier extends StateNotifier<GenresState> {
  final MovieService _movieService;

  GenresNotifier(this._movieService) : super(GenresState.initial());

  Future<void> fetchGenres() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _movieService.fetchGenres();
      state = state.copyWith(genres: data, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final genresProvider =
    StateNotifierProvider<GenresNotifier, GenresState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return GenresNotifier(movieService);
});

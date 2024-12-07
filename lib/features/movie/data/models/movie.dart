// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    required bool adult,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'genre_ids') List<int>? genreIds,
    required int id,
    @JsonKey(name: 'original_language') required String originalLanguage,
    @JsonKey(name: 'original_title') required String originalTitle,
    required String overview,
    required double popularity,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') required String releaseDate,
    required String title,
    required bool video,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'vote_count') required int voteCount,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

// Ekstensi untuk menambahkan getter imageUrl
extension MovieImageUrl on Movie {
  String _getImageUrl(String size, {bool isBackdrop = false}) {
    return posterPath != null
        ? 'https://image.tmdb.org/t/p/$size${isBackdrop ? backdropPath : posterPath}'
        : 'https://img.icons8.com/?size=480&id=gX6VczTLnV3E&format=png';
  }

  String get backdropUrlOriginal => _getImageUrl('original', isBackdrop: true);
  String get backdropUrlW500 => _getImageUrl('w500', isBackdrop: true);
  String get backdropUrlW300 => _getImageUrl('w300', isBackdrop: true);
  String get imageUrlOriginal => _getImageUrl('original');
  String get imageUrlW500 => _getImageUrl('w500');
  String get imageUrlW300 => _getImageUrl('w300');
  String get imageUrlW200 => _getImageUrl('w200');
}

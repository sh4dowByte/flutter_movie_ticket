// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'genres.freezed.dart';
part 'genres.g.dart';

@freezed
class Genres with _$Genres {
  const factory Genres({
    required int id,
    required String name,
  }) = _Genres;

  factory Genres.fromJson(Map<String, dynamic> json) => _$GenresFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cast.freezed.dart';
part 'cast.g.dart';

@freezed
class Cast with _$Cast {
  const factory Cast({
    required bool adult,
    required int gender,
    required int id,
    @JsonKey(name: 'known_for_department') required String knownForDepartment,
    required String name,
    @JsonKey(name: 'original_name') required String originalName,
    required double popularity,
    @JsonKey(name: 'profile_path') String? profilePath,
    @JsonKey(name: 'cast_id') required int castId,
    required String character,
    @JsonKey(name: 'credit_id') required String creditId,
    required int order,
  }) = _Cast;

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

extension CastImageUrl on Cast {
  String get imageUrlOriginal => profilePath != null
      ? 'https://image.tmdb.org/t/p/original$profilePath'
      : 'https://img.icons8.com/?size=480&id=z-JBA_KtSkxG&format=png';

  String get imageUrlW500 => profilePath != null
      ? 'https://image.tmdb.org/t/p/w500$profilePath'
      : 'https://img.icons8.com/?size=480&id=z-JBA_KtSkxG&format=png';

  String get imageUrlW300 => profilePath != null
      ? 'https://image.tmdb.org/t/p/w300$profilePath'
      : 'https://img.icons8.com/?size=480&id=z-JBA_KtSkxG&format=png';
}

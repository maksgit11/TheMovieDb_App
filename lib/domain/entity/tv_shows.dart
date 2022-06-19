import 'package:json_annotation/json_annotation.dart';

part 'tv_shows.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TvShows {
  final String? posterPath;
  final double popularity;
  final int id;
  final String? backdropPath;
  final double voteAverage;
  final String overview;
  final String firstAirDate;
  final List<String> originCountry;
  final List<int> genreIds;
  final String originalLanguage;
  final int voteCount;
  final String name;
  final String originalName;
  TvShows({
    required this.posterPath,
    required this.popularity,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.firstAirDate,
    required this.originCountry,
    required this.genreIds,
    required this.originalLanguage,
    required this.voteCount,
    required this.name,
    required this.originalName,
  });

  factory TvShows.fromJson(Map<String, dynamic> json) => _$TvShowsFromJson(json);
  Map<String, dynamic> toJson() => _$TvShowsToJson(this);
}

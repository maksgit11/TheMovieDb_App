import 'package:json_annotation/json_annotation.dart';
import 'package:themovie_db/domain/entity/tv_shows.dart';

part 'popular_tv_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularTvResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<TvShows> tv;
  final int totalResults;
  final int totalPages;

  PopularTvResponse({
    required this.page,
    required this.tv,
    required this.totalResults,
    required this.totalPages,
  });

  factory PopularTvResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularTvResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PopularTvResponseToJson(this);
}

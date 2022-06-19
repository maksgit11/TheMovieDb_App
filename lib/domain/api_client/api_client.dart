import 'dart:io';
import 'dart:convert';

import 'package:themovie_db/domain/entity/popular_movie_response.dart';
import 'package:themovie_db/domain/entity/movie_detail.dart';
import 'package:themovie_db/domain/entity/popular_tv_response.dart';

enum ApiClientExceptionType { network, auth, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

class ApiClient {
  final _client = HttpClient();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = 'b85d2845057fd3952ce26d3033631367';

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
      username: username,
      password: password,
      requestToken: token,
    );
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = await response.jsonDecode();
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      final dynamic json = await response.jsonDecode();
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<String> _makeToken() async {
    final result = _get(
      '/authentication/token/new',
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final token = jsonMap['request_token'] as String;
        return token;
      },
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Future<int> getAccountInfo(
    String sessionId,
  ) async {
    final result = _get(
      '/account',
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final result = jsonMap['id'] as int;
        return result;
      },
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<PopularTvResponse> popularTVShows(int page, String locale) async {
    final result = _get(
      '/tv/popular',
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final response = PopularTvResponse.fromJson(jsonMap);
        return response;
      },
      <String, dynamic>{
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    final result = _get(
      '/movie/popular',
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final response = PopularMovieResponse.fromJson(jsonMap);
        return response;
      },
      <String, dynamic>{
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  Future<PopularMovieResponse> searchedMovie(
    int page,
    String locale,
    String query,
  ) async {
    final result = _get(
      '/search/movie',
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final response = PopularMovieResponse.fromJson(jsonMap);
        return response;
      },
      <String, dynamic>{
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    final result = _get(
      '/movie/$movieId',
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final response = MovieDetails.fromJson(jsonMap);
        return response;
      },
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': _apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    final result = _get(
      '/movie/$movieId/account_states',
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final result = jsonMap['favorite'] as bool;
        return result;
      },
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<int> markAsFavorite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': isFavorite,
    };
    final result = _post(
      '/account/$accountId/favorite',
      parameters,
      (dynamic json) {
        return 1;
      },
      <String, dynamic>{
        'api_key': _apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    final result = _post(
      '/authentication/token/validate_with_login',
      parameters,
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final token = jsonMap['request_token'] as String;
        return token;
      },
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };
    final result = _post(
      '/authentication/session/new',
      parameters,
      (dynamic json) {
        final jsonMap = json as Map<String, dynamic>;
        final sessionId = jsonMap['session_id'] as String;
        return sessionId;
      },
      <String, dynamic>{'api_key': _apiKey},
    );
    return result;
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}

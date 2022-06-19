import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themovie_db/domain/api_client/api_client.dart';
import 'package:themovie_db/domain/entity/tv_shows.dart';

class TvShowListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _tv = <TvShows>[];
  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  // String? _searchQuery;
  String _locale = '';
  // Timer? searchDebounce;
  List<TvShows> get tv => List.unmodifiable(_tv);
  late DateFormat _dateFormat;

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  DateTime? parseTvDateFromString(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;
    return DateTime.tryParse(rawDate);
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    _currentPage = 0;
    _totalPage = 1;
    _tv.clear();
    await _loadTvShows();
  }

  Future<void> _loadTvShows() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final tvResponse = await _apiClient.popularTVShows(nextPage, _locale);
      _tv.addAll(tvResponse.tv);
      _currentPage = tvResponse.page;
      _totalPage = tvResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  void showedTvAtIndex(int index) {
    if (index < _tv.length - 1) return;
    _loadTvShows();
  }
  //  void onTvTap(BuildContext context, int index) {
  //   final id = _tv[index].id;
  //   Navigator.of(context).pushNamed(
  //     MainNavigationRouteNames.movieDetails,
  //     arguments: id,
  //   );
  // }

  // Future<void> _resetList() async {
  //   _currentPage = 0;
  //   _totalPage = 1;
  //   _movies.clear();
  //   await _loadNextPage();
  // }

  // Future<PopularMovieResponse> _loadMovies(int nextPage, String locale) async {
  //   final query = _searchQuery;
  //   if (query == null) {
  //     return await _apiClient.popularMovie(nextPage, _locale);
  //   } else {
  //     return await _apiClient.searchedMovie(nextPage, _locale, query);
  //   }
  // }

  // Future<void> _loadNextPage() async {
  //   if (_isLoadingInProgress || _currentPage >= _totalPage) return;
  //   _isLoadingInProgress = true;
  //   final nextPage = _currentPage + 1;

  //   final moviesResponse = await _loadMovies(nextPage, _locale);
  //   _movies.addAll(moviesResponse.movies);
  //   _currentPage = moviesResponse.page;
  //   _totalPage = moviesResponse.totalPages;
  //   _isLoadingInProgress = false;
  //   notifyListeners();
  // }

  // Future<void> searchMovie(String text) async {
  //   searchDebounce?.cancel();
  //   searchDebounce = Timer(const Duration(milliseconds: 200), () async {
  //     final searchQuery = text.isNotEmpty ? text : null;
  //     if (_searchQuery == searchQuery) return;
  //     _searchQuery = searchQuery;
  //     await _resetList();
  //   });
  // }

}

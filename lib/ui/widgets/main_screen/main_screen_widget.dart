import 'package:flutter/material.dart';
import 'package:themovie_db/library/inherited/provider.dart';
import 'package:themovie_db/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themovie_db/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:themovie_db/ui/widgets/news/news_model.dart';
import 'package:themovie_db/ui/widgets/news/news_widget.dart';
import 'package:themovie_db/ui/widgets/tv_shows_list/tv_show_list_model.dart';
import 'package:themovie_db/ui/widgets/tv_shows_list/tv_show_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();
  final tvShowListModel = TvShowListModel();
  final newsModel = NewsModel();

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieListModel.setupLocale(context);
    tvShowListModel.setupLocale(context);
    newsModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: [
          NotifierProvider(
            create: () => newsModel,
            isManagingModel: false,
            child: const NewsWidget(),
          ),
          NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: const MovieListWidget(),
          ),
          NotifierProvider(
            create: () => tvShowListModel,
            isManagingModel: false,
            child: const TvShowListWidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Сериалы',
          ),
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}

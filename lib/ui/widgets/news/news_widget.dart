import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:themovie_db/domain/api_client/api_client.dart';
import 'package:themovie_db/domain/data_providers/session_data_provider.dart';
import 'package:themovie_db/library/inherited/provider.dart';
import 'package:themovie_db/resources/resources.dart';
import 'package:themovie_db/ui/widgets/news/news_header_widget.dart';
import 'package:themovie_db/ui/widgets/news/news_model.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage(AppImages.titleIcon1),
          width: 80,
          height: 80,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => SessionDataProvider().setSessionId(null),
            icon: const Icon(FontAwesomeIcons.arrowRightFromBracket, size: 22),
          ),
        ],
      ),
      body: ListView(
        children: const [
          NewsHeaderWidget(),
          SizedBox(height: 20),
          NewsPopularMovieWidget(),
        ],
      ),
    );
  }
}

class NewsPopularMovieWidget extends StatelessWidget {
  const NewsPopularMovieWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<NewsModel>(context);
    if (model == null) return const SizedBox.shrink();
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Что популярно',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 21,
              ),
            ),
          ),
          SizedBox(
            height: 335,
            child: Scrollbar(
              radius: const Radius.circular(10),
              child: ListView.builder(
                itemCount: model.movies.length,
                itemExtent: 150,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  model.showedMovieAtIndex(index);
                  final movie = model.movies[index];
                  final posterPath = movie.posterPath;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: [
                            posterPath != null
                                ? Image.network(ApiClient.imageUrl(posterPath))
                                : const SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    model.stringFromDate(movie.releaseDate),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Социальные сети',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.facebookSquare,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.twitter,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.instagram,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.neos,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

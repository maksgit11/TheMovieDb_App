import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:themovie_db/domain/api_client/api_client.dart';
import 'package:themovie_db/domain/entity/movie_details_credits.dart';
import 'package:themovie_db/library/inherited/provider.dart';
import 'package:themovie_db/ui/navigation/main_navigation.dart';
import 'package:themovie_db/ui/theme/app_colors.dart';
import 'package:themovie_db/ui/theme/app_text_style.dart';
import 'package:themovie_db/ui/widgets/elements/radial_percent_widget.dart';
import 'package:themovie_db/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummeryWidget(),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
          child: _DescriptionWidget(),
        ),
        SizedBox(height: 15),
        _PeopleWidget(),
      ],
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        NotifierProvider.of<MovieDetailsModel>(context)?.movieDetails;
    var voteAverage = movieDetails?.voteAverage ?? 0;
    final videos = movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    voteAverage = voteAverage * 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: RadialPercentWidget(
                  child: Text(voteAverage.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 18)),
                  percent: voteAverage / 100,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 4,
                ),
              ),
              const SizedBox(width: 10),
              const Text('User Score'),
            ],
          ),
        ),
        Container(width: 1.5, height: 25, color: Colors.grey),
        trailerKey != null
            ? TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.movietrailerWidget,
                  arguments: trailerKey,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.play_arrow,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text('Play  Trailer'),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Обзор',
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);

    return Text(
      model?.movieDetails?.overview ?? '',
      maxLines: 7,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.justify,
      style: AppTextStyle.moviesText,
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imageUrl(backdropPath))
              : const SizedBox.shrink(),
          Positioned(
            top: 15,
            left: 15,
            bottom: 15,
            child: posterPath != null
                ? Image.network(ApiClient.imageUrl(posterPath))
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(
                model?.isFavorite == true
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                color: model?.isFavorite == true ? Colors.red : Colors.white,
              ),
              onPressed: () => model?.toggleFavorite(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? '  ($year)' : '';
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(
          children: [
            TextSpan(
              text: model?.movieDetails?.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
            TextSpan(
              text: year,
              style: AppTextStyle.moviesText,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    var texts = <String>[];
    var genresNames = <String>[];
    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }
    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
    }

    return ColoredBox(
      color: AppColors.darkBlueColor2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Center(
          child: Column(
            children: [
              Text(
                texts.join(' '),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: AppTextStyle.moviesText,
              ),
              Text(
                genresNames.join(', '),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.moviesText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }
    return Column(
      children:
          crewChunks.map((chunk) => _PeopleWidgetRow(employes: chunk)).toList(),
    );
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<Employee> employes;
  const _PeopleWidgetRow({
    Key? key,
    required this.employes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: employes
          .map((employee) => _PeopleWidgetRowItem(employee: employee))
          .toList(),
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final Employee employee;
  const _PeopleWidgetRowItem({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
    const jobTitleStyle = TextStyle(
        fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.name, style: nameStyle),
            Text(employee.job, style: jobTitleStyle),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:themovie_db/resources/resources.dart';

class NewsHeaderWidget extends StatelessWidget {
  const NewsHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Image(
          image: AssetImage(AppImages.newsHeader),
          height: 305,
          fit: BoxFit.fitHeight,
        ),
        Positioned(
          top: 15,
          left: 15,
          right: 15,
          child: Column(
            children: [
              const Text(
                'Добро пожаловать.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 42,
                ),
              ),
              const Text(
                'Миллионы фильмов, сериалов и людей. Исследуйте сейчас.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 29,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  isDense: true,
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0,
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        colors: [
                          Color.fromARGB(255, 30, 213, 192),
                          Color.fromARGB(240, 1, 180, 228),
                        ],
                      ),
                      color: const Color.fromARGB(255, 13, 197, 126),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.0),
                        shadowColor: Colors.transparent,
                        primary: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text('Search'),
                    ),
                  ),
                  hintText: 'Поиск...',
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

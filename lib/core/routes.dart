import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/features/ticket/presentation/screens/screens.dart';

import '../features/movie/presentation/screens/screens.dart';
import '../screens/menu.dart';

class Routes {
  static const String menu = '/menu';
  static const String movieDetail = '/movie_detail';
  static const String movieSearch = '/movie_search';
  static const String seeMore = '/see_more';
  static const String seats = '/seats';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case menu:
        return MaterialPageRoute(builder: (_) => const MenuPage());

      case movieDetail:
        final int movieId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => MovieDetailPage(movieId));

      case movieSearch:
        return MaterialPageRoute(builder: (_) => const MovieSearchPage());

      case seats:
        return MaterialPageRoute(builder: (_) => const SeatsPage());

      case seeMore:
        final args = settings.arguments as Map<String, dynamic>;
        final genreId = args['genreId'];
        final title = args['title'];
        final provider = args['providerKey'];
        return MaterialPageRoute(
            builder: (_) => SeeMorePage(
                  title,
                  provider,
                  genreId: genreId,
                ));

      case '/':
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Routes'),
                    centerTitle: true, // Judul di tengah
                  ),
                  body: const Center(
                    child: Text('Routes Not Found'),
                  ),
                ));
    }
  }
}

import 'package:flutter/material.dart';
import '../screen/screen.dart';

class Routes {
  static const String menu = '/menu';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case menu:
        return MaterialPageRoute(builder: (_) => const MenuPage());

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

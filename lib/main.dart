import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movie_booking_app/features/ticket/data/models/ticket.dart';
import 'package:flutter_movie_booking_app/features/ticket/data/services/db_services.dart';
import 'package:flutter_movie_booking_app/screens/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_theme.dart';
import 'core/routes.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Booking App',
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      onGenerateRoute: Routes.generateRoute,
      home: const MenuPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final DBService dbService = DBService();

  HomePage({super.key});

  Future<void> _addTicket() async {
    await dbService.insertTicket(Ticket.fromMap({
      'movie_name': 'Armor',
      'movie_poster': '/pnXLFioDeftqjlCVlRmXvIdMsdP.jpg',
      'movie_backdrop': '/evFChfYeD2LqobEJf8iQsrYcGTw.jpg',
      'movie_duration': 126,
      'location': 'Cinepolis',
      'date': '2024-10-02',
      'time': '12.00',
      'seat': 'J15',
      'room_number': '10',
      'trx_id': '189301283719827',
    }));
  }

  Future<void> _showTicket() async {
    List<Ticket> users = await dbService.getTicket();
    print(users.map((e) => e.toMap()));
  }

  Future<void> _removeTicket() async {
    await dbService.deleteTicket(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DBService Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _addTicket,
              child: Text('Add Ticket'),
            ),
            ElevatedButton(
              onPressed: _showTicket,
              child: Text('Show Ticket'),
            ),
            ElevatedButton(
              onPressed: _removeTicket,
              child: Text('Remove Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}

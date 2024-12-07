import 'package:flutter_movie_booking_app/features/ticket/data/models/ticket.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;

  DBService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tickets.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ticket (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        movie_name TEXT NOT NULL,
        movie_poster TEXT NOT NULL,
        movie_backdrop TEXT NOT NULL,
        movie_duration INTEGER NOT NULL,
        location TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        room_number TEXT NOT NULL,
        trx_id TEXT NOT NULL,
        seat TEXT NOT NULL
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertTicket(Ticket ticket) async {
    final db = await database;
    return await db.insert('ticket', ticket.toMap());
  }

  Future<List<Ticket>> getTicket() async {
    final db = await database;
    final data = await db.query('ticket');
    return data.map((data) => Ticket.fromMap(data)).toList();
  }

  Future<int> updateticket(int id, Ticket ticket) async {
    final db = await database;
    return await db.update(
      'ticket',
      ticket.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTickets() async {
    final db = await database;
    await db.delete('ticket'); // Deletes all rows in the 'ticket' table
  }

  Future<int> deleteTicket(int id) async {
    final db = await database;
    return await db.delete(
      'ticket',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

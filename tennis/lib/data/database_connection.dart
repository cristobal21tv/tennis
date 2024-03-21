import 'dart:convert';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  static final DatabaseConnection instance =
      DatabaseConnection._privateConstructor();
  static Database? _database;

  DatabaseConnection._privateConstructor();
  // Abrir la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tennis.db');
    return await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
  }

  _onCreatingDatabase(Database db, int version) async {
    await db
        .execute(
          'CREATE TABLE IF NOT EXISTS Bookings (id	INTEGER NOT NULL UNIQUE, Court TEXT NOT NULL, Date	TEXT NOT NULL, UserName	TEXT NOT NULL, clima TEXT NOT NULL, PRIMARY KEY(id));',
        )
        .then((value) => log('tabla Bookings creada'))
        .onError((error, stackTrace) => log(jsonDecode(error.toString())));
  }
}

import 'dart:developer' as dev;

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wokubot/media_entry.dart';

class DatabaseAdapter {
  static final String _databaseName = 'media';
  static final String _databaseExtension = '.db';
  static final int _databaseVersion = 1; // increment on schema change

  DatabaseAdapter._privateConstructor();
  static final DatabaseAdapter instance = DatabaseAdapter._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    dev.log('Initializing database $_databaseName ...', name: 'DatabaseAdapter');
    WidgetsFlutterBinding.ensureInitialized();

    return await openDatabase(
      join(await getDatabasesPath(), _databaseName, _databaseExtension),
      onCreate: (db, version) async {
        dev.log('Creating database $_databaseName ...', name: 'DatabaseAdapter');
        return await db.execute(
          "CREATE TABLE $_databaseName(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, name TEXT, description TEXT, file TEXT)",
        );
      },
      version: _databaseVersion,
    );
  }

  Future<int> insertMedia(MediaEntry entry) async {
    dev.log('Inserting ${entry.toString()} into database $_databaseName ...', name: 'DatabaseAdapter');
    final Database db = await database;

    return await db.insert(_databaseName, entry.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MediaEntry>> getAllMedia() async {
    dev.log('Getting all media from database $_databaseName ...', name: 'DatabaseAdapter');
    final Database db = await database;
    final List<Map<String, dynamic>> media = await db.query(_databaseName);

    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    });
  }

  Future<void> updateMedia(MediaEntry entry) async {
    dev.log('Updating ${entry.toString()} in database $_databaseName ...', name: 'DatabaseAdapter');
    final Database db = await database;

    await db.update(
      _databaseName,
      entry.toMap(),
      where: "id = ?",
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteMedia(int id) async {
    dev.log('Deleting MediaEntry with id $id from database $_databaseName ...', name: 'DatabaseAdapter');
    final Database db = await database;

    await db.delete(
      _databaseName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAllMedia() async {
    dev.log('Deleting all media from database $_databaseName ...', name: 'DatabaseAdapter');
    final Database db = await database;

    await db.delete(_databaseName);
  }
}

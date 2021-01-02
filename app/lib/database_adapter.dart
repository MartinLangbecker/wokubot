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
    WidgetsFlutterBinding.ensureInitialized();

    return await openDatabase(
      join(await getDatabasesPath(), _databaseName, _databaseExtension),
      onCreate: (db, version) {
        dev.log('created database $_databaseName', name: 'DatabaseAdapter');
        return db.execute(
          "CREATE TABLE $_databaseName(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, name TEXT, description TEXT, file TEXT)",
        );
      },
      version: _databaseVersion,
    );
  }

  Future<int> insertMedia(MediaEntry entry) async {
    final Database db = await database;

    dev.log('Insert MediaEntry ${entry.toString()} into database $_databaseName', name: 'DatabaseAdapter');
    return await db.insert(_databaseName, entry.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MediaEntry>> getAllMedia() async {
    final Database db = await database;
    final List<Map<String, dynamic>> media = await db.query(_databaseName);

    dev.log('Get all media from database $_databaseName', name: 'DatabaseAdapter');
    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    });
  }

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<List<MediaEntry>> getMediaByType(MediaType type) async {
    final Database db = await database;
    final List<Map<String, dynamic>> media = await db.query(
      _databaseName,
      where: "type = ?",
      whereArgs: [type.toString()],
    );

    dev.log('Get media by type ${type.toString()} from database $_databaseName', name: 'DatabaseAdapter');
    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    });
  }

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<MediaEntry> getMediaById(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> media = await db.query(
      _databaseName,
      where: "id = ?",
      whereArgs: [id],
    );

    dev.log('Get media by id $id from database $_databaseName', name: 'DatabaseAdapter');
    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    }).single;
  }

  Future<void> updateMedia(MediaEntry entry) async {
    final Database db = await database;

    dev.log('Update MediaEntry ${entry.toString()} in database $_databaseName', name: 'DatabaseAdapter');
    await db.update(
      _databaseName,
      entry.toMap(),
      where: "id = ?",
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteMedia(int id) async {
    final Database db = await database;

    dev.log('Delete MediaEntry with id $id from database $_databaseName', name: 'DatabaseAdapter');
    await db.delete(
      _databaseName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAllMedia() async {
    final Database db = await database;

    dev.log('Delete all media from database $_databaseName', name: 'DatabaseAdapter');
    await db.delete(_databaseName);
  }
}

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wokubot/media_entry.dart';

class DatabaseAdapter {
  static final _databaseName = "media.db";
  static final _databaseVersion = 1; // increment on schema change

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
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE media(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, name TEXT, description TEXT, file TEXT)",
        );
      },
      version: _databaseVersion,
    );
  }

  Future<int> insertMedia(MediaEntry entry) async {
    final Database db = await database;

    return await db.insert('media', entry.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MediaEntry>> getAllMedia() async {
    final Database db = await database;

    final List<Map<String, dynamic>> media = await db.query('media');

    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    });
  }

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<List<MediaEntry>> getMediaByType(MediaType type) async {
    final Database db = await database;

    final List<Map<String, dynamic>> media = await db.query(
      'media',
      where: "type = ?",
      whereArgs: [type.toString()],
    );

    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    });
  }

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<MediaEntry> getMediaById(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> media = await db.query(
      'media',
      where: "id = ?",
      whereArgs: [id],
    );

    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    }).single;
  }

  Future<void> updateMedia(MediaEntry entry) async {
    final Database db = await database;

    await db.update(
      'media',
      entry.toMap(),
      where: "id = ?",
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteMedia(int id) async {
    final Database db = await database;

    await db.delete(
      'media',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAllMedia() async {
    final Database db = await database;

    await db.delete('media');
  }
}

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wokubot/media_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'media.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE media(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, name TEXT, description TEXT, file TEXT)",
      );
    },
    version: 1,
  );

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<void> insertMedia(MediaEntry entry) async {
    final Database db = await database;

    await db.insert('media', entry.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<List<MediaEntry>> getAllMedia() async {
    final Database db = await database;

    final List<Map<String, dynamic>> media = await db.query('media');

    return List<MediaEntry>.generate(media.length, (i) {
      return MediaEntry.fromMap(media[i]);
    });
  }

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<List<MediaEntry>> getMediaByType(String type) async {
    final Database db = await database;

    final List<Map<String, dynamic>> media = await db.query(
      'media',
      where: "type = ?",
      whereArgs: [type],
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

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<void> updateMedia(MediaEntry entry) async {
    final Database db = await database;

    await db.update(
      'media',
      entry.toMap(),
      where: "id = ?",
      whereArgs: [entry.id],
    );
  }

  // TODO: remove hint once method is used
  // ignore: unused_element
  Future<void> deleteMedia(int id) async {
    final Database db = await database;

    await db.delete(
      'media',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

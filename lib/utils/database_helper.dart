import 'dart:io';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  DataBaseHelper._privateContructor();
  static final DataBaseHelper instance = DataBaseHelper._privateContructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: migration,
    );
  }

  Future migration(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        avatar TEXT,
        name TEXT,
        zipCode TEXT,
        city TEXT,
        state TEXT,
        address TEXT,
        number TEXT,
        complement TEXT
      )
    ''');
      await db.execute('''
      CREATE TABLE phones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT,
        FK_contact_id INTEGER NOT NULL,
        FOREIGN KEY(FK_contact_id) references contacts(id)
      )
    ''');
      Logger().i('DATABASE => DATABASE CREATED SUCESSFULLY');
    } catch (e) {
      Logger().e('ERROR => $e.message');
      Logger().e(e);
    }
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/image_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bai6_images.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertImage(ImageItem image) async {
    final db = await database;
    return await db.insert('images', image.toMap());
  }

  Future<List<ImageItem>> getAllImages() async {
    final db = await database;
    final result = await db.query('images', orderBy: 'id DESC');
    return result.map((m) => ImageItem.fromMap(m)).toList();
  }

  Future<int> deleteImage(int id) async {
    final db = await database;
    return await db.delete('images', where: 'id = ?', whereArgs: [id]);
  }
}

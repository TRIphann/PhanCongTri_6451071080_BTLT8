import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/word.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bai5_dictionary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dictionary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL
      )
    ''');
  }

  Future<bool> isDatabaseEmpty() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM dictionary');
    final count = result.first['count'] as int;
    return count == 0;
  }

  Future<void> insertWords(List<Word> words) async {
    final db = await database;
    final batch = db.batch();
    for (var word in words) {
      batch.insert('dictionary', word.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Word>> searchWords(String query) async {
    final db = await database;
    final result = await db.query(
      'dictionary',
      where: 'word LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'word ASC',
      limit: 50,
    );
    return result.map((m) => Word.fromMap(m)).toList();
  }

  Future<List<Word>> getAllWords() async {
    final db = await database;
    final result = await db.query('dictionary', orderBy: 'word ASC');
    return result.map((m) => Word.fromMap(m)).toList();
  }
}

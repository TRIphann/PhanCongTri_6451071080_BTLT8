import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Lấy instance database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bai1_notes.db');
    return _database!;
  }

  // Khởi tạo database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Tạo bảng notes
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');
  }

  // Thêm ghi chú mới
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Lấy tất cả ghi chú
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'id DESC');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // Lấy ghi chú theo id
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  // Cập nhật ghi chú
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Xóa ghi chú
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Đóng database
  Future close() async {
    final db = await database;
    db.close();
  }
}

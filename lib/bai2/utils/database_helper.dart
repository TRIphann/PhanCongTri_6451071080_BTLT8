import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bai2_notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Tạo bảng categories và notes với khóa ngoại
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id)
          ON DELETE CASCADE
      )
    ''');

    // Thêm một số danh mục mẫu
    await db.insert('categories', {'name': 'Công việc'});
    await db.insert('categories', {'name': 'Cá nhân'});
    await db.insert('categories', {'name': 'Học tập'});
  }

  // ==================== CATEGORY OPERATIONS ====================

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final result = await db.query('categories', orderBy: 'name ASC');
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    // Xóa tất cả ghi chú thuộc danh mục trước
    await db.delete('notes', where: 'categoryId = ?', whereArgs: [id]);
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== NOTE OPERATIONS ====================

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Lấy tất cả ghi chú kèm tên danh mục (JOIN)
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT notes.*, categories.name as categoryName
      FROM notes
      INNER JOIN categories ON notes.categoryId = categories.id
      ORDER BY notes.id DESC
    ''');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // Lọc ghi chú theo danh mục
  Future<List<Note>> getNotesByCategory(int categoryId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT notes.*, categories.name as categoryName
      FROM notes
      INNER JOIN categories ON notes.categoryId = categories.id
      WHERE notes.categoryId = ?
      ORDER BY notes.id DESC
    ''', [categoryId]);
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

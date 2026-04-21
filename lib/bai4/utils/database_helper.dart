import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bai4_expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        note TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Seed data
    await db.insert('categories', {'name': 'Ăn uống'});
    await db.insert('categories', {'name': 'Di chuyển'});
    await db.insert('categories', {'name': 'Mua sắm'});
    await db.insert('categories', {'name': 'Giải trí'});
  }

  // Category operations
  Future<int> insertCategory(Category cat) async {
    final db = await database;
    return await db.insert('categories', cat.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final result = await db.query('categories', orderBy: 'name ASC');
    return result.map((m) => Category.fromMap(m)).toList();
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'categoryId = ?', whereArgs: [id]);
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // Expense operations
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT expenses.*, categories.name as categoryName
      FROM expenses
      INNER JOIN categories ON expenses.categoryId = categories.id
      ORDER BY expenses.id DESC
    ''');
    return result.map((m) => Expense.fromMap(m)).toList();
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update('expenses', expense.toMap(), where: 'id = ?', whereArgs: [expense.id]);
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Tổng tiền theo category
  Future<List<Map<String, dynamic>>> getTotalByCategory() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT categories.name, SUM(expenses.amount) as total
      FROM expenses
      INNER JOIN categories ON expenses.categoryId = categories.id
      GROUP BY categories.id
      ORDER BY total DESC
    ''');
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';
import '../models/course.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bai7_enrollment.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE enrollments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        courseId INTEGER NOT NULL,
        FOREIGN KEY (studentId) REFERENCES students (id) ON DELETE CASCADE,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE,
        UNIQUE(studentId, courseId)
      )
    ''');

    // Seed data
    await db.insert('students', {'name': 'Nguyễn Văn A'});
    await db.insert('students', {'name': 'Trần Thị B'});
    await db.insert('students', {'name': 'Lê Văn C'});
    await db.insert('courses', {'name': 'Lập trình di động'});
    await db.insert('courses', {'name': 'Cơ sở dữ liệu'});
    await db.insert('courses', {'name': 'Mạng máy tính'});
  }

  // Student operations
  Future<int> insertStudent(Student s) async {
    final db = await database;
    return await db.insert('students', s.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final result = await db.query('students', orderBy: 'name ASC');
    return result.map((m) => Student.fromMap(m)).toList();
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    await db.delete('enrollments', where: 'studentId = ?', whereArgs: [id]);
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  // Course operations
  Future<int> insertCourse(Course c) async {
    final db = await database;
    return await db.insert('courses', c.toMap());
  }

  Future<List<Course>> getAllCourses() async {
    final db = await database;
    final result = await db.query('courses', orderBy: 'name ASC');
    return result.map((m) => Course.fromMap(m)).toList();
  }

  Future<int> deleteCourse(int id) async {
    final db = await database;
    await db.delete('enrollments', where: 'courseId = ?', whereArgs: [id]);
    return await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  // Enrollment operations
  Future<int> enroll(int studentId, int courseId) async {
    final db = await database;
    return await db.insert('enrollments', {'studentId': studentId, 'courseId': courseId});
  }

  Future<int> unenroll(int studentId, int courseId) async {
    final db = await database;
    return await db.delete('enrollments',
        where: 'studentId = ? AND courseId = ?', whereArgs: [studentId, courseId]);
  }

  Future<List<Course>> getCoursesForStudent(int studentId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT courses.* FROM courses
      INNER JOIN enrollments ON courses.id = enrollments.courseId
      WHERE enrollments.studentId = ?
      ORDER BY courses.name ASC
    ''', [studentId]);
    return result.map((m) => Course.fromMap(m)).toList();
  }

  Future<List<int>> getEnrolledCourseIds(int studentId) async {
    final db = await database;
    final result = await db.query('enrollments',
        columns: ['courseId'], where: 'studentId = ?', whereArgs: [studentId]);
    return result.map((m) => m['courseId'] as int).toList();
  }
}

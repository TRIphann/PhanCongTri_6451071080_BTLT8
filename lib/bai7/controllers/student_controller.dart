import '../models/student.dart';
import '../models/course.dart';
import '../utils/database_helper.dart';

class StudentController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Student>> getAllStudents() async {
    return await _dbHelper.getAllStudents();
  }

  Future<bool> addStudent(String name) async {
    if (name.trim().isEmpty) return false;
    final s = Student(name: name.trim());
    final id = await _dbHelper.insertStudent(s);
    return id > 0;
  }

  Future<bool> deleteStudent(int id) async {
    final result = await _dbHelper.deleteStudent(id);
    return result > 0;
  }

  Future<List<Course>> getCoursesForStudent(int studentId) async {
    return await _dbHelper.getCoursesForStudent(studentId);
  }

  Future<List<Course>> getAllCourses() async {
    return await _dbHelper.getAllCourses();
  }

  Future<bool> addCourse(String name) async {
    if (name.trim().isEmpty) return false;
    final c = Course(name: name.trim());
    final id = await _dbHelper.insertCourse(c);
    return id > 0;
  }

  Future<List<int>> getEnrolledCourseIds(int studentId) async {
    return await _dbHelper.getEnrolledCourseIds(studentId);
  }

  Future<void> enroll(int studentId, int courseId) async {
    await _dbHelper.enroll(studentId, courseId);
  }

  Future<void> unenroll(int studentId, int courseId) async {
    await _dbHelper.unenroll(studentId, courseId);
  }
}

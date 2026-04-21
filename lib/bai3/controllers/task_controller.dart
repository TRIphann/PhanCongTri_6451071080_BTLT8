import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';
import '../utils/database_helper.dart';

class TaskController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Task>> getAllTasks() async {
    return await _dbHelper.getAllTasks();
  }

  Future<bool> addTask(String title) async {
    if (title.trim().isEmpty) return false;
    final task = Task(title: title.trim());
    final id = await _dbHelper.insertTask(task);
    return id > 0;
  }

  Future<bool> toggleTask(Task task) async {
    final updated = task.copyWith(isDone: !task.isDone);
    final result = await _dbHelper.updateTask(updated);
    return result > 0;
  }

  Future<bool> deleteTask(int id) async {
    final result = await _dbHelper.deleteTask(id);
    return result > 0;
  }

  // Export tất cả tasks ra file JSON
  Future<String> exportToJson() async {
    final tasks = await _dbHelper.getAllTasks();
    final jsonList = tasks.map((t) => t.toJson()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/tasks_backup.json');
    await file.writeAsString(jsonString);
    return file.path;
  }

  // Import tasks từ file JSON
  Future<int> importFromJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/tasks_backup.json');

    if (!await file.exists()) {
      throw Exception('Không tìm thấy file backup!');
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final tasks = jsonList.map((j) => Task.fromJson(j as Map<String, dynamic>)).toList();

    // Xóa tất cả tasks cũ rồi import mới
    await _dbHelper.deleteAllTasks();
    await _dbHelper.insertAllTasks(tasks);
    return tasks.length;
  }
}

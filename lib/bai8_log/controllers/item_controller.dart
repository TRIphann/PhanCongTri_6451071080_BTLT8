import '../models/item.dart';
import '../models/log_entry.dart';
import '../utils/database_helper.dart';
import '../utils/file_logger.dart';

class ItemController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Item>> getAllItems() async {
    return await _dbHelper.getAllItems();
  }

  Future<bool> addItem(String name) async {
    if (name.trim().isEmpty) return false;
    final item = Item(name: name.trim());
    final id = await _dbHelper.insertItem(item);
    if (id > 0) {
      await _writeLog('THÊM: "${name.trim()}"');
      return true;
    }
    return false;
  }

  Future<bool> updateItem(int id, String name) async {
    if (name.trim().isEmpty) return false;
    final item = Item(id: id, name: name.trim());
    final result = await _dbHelper.updateItem(item);
    if (result > 0) {
      await _writeLog('SỬA: id=$id -> "${name.trim()}"');
      return true;
    }
    return false;
  }

  Future<bool> deleteItem(int id, String name) async {
    final result = await _dbHelper.deleteItem(id);
    if (result > 0) {
      await _writeLog('XÓA: "$name" (id=$id)');
      return true;
    }
    return false;
  }

  Future<List<LogEntry>> getAllLogs() async {
    return await _dbHelper.getAllLogs();
  }

  Future<String> getFileLog() async {
    return await FileLogger.readLogs();
  }

  Future<void> _writeLog(String action) async {
    final time = DateTime.now().toString();
    // Ghi vào database
    final log = LogEntry(action: action, time: time);
    await _dbHelper.insertLog(log);
    // Ghi vào file
    await FileLogger.writeLog(action);
  }
}

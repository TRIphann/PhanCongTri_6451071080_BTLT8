import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileLogger {
  static Future<void> writeLog(String action) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/activity_log.txt');
    final time = DateTime.now().toString();
    final logLine = '[$time] $action\n';
    await file.writeAsString(logLine, mode: FileMode.append);
  }

  static Future<String> readLogs() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/activity_log.txt');
    if (await file.exists()) {
      return await file.readAsString();
    }
    return 'Chưa có log nào.';
  }
}

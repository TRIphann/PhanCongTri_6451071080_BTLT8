import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SessionManager {
  static const _fileName = 'login_session.json';

  // Lưu thông tin đăng nhập vào file
  static Future<void> saveSession(String email, String password) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    final data = jsonEncode({'email': email, 'password': password});
    await file.writeAsString(data);
  }

  // Đọc thông tin session
  static Future<Map<String, String>?> getSession() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_fileName');
      if (await file.exists()) {
        final content = await file.readAsString();
        final map = jsonDecode(content) as Map<String, dynamic>;
        return {
          'email': map['email'] as String,
          'password': map['password'] as String,
        };
      }
    } catch (_) {}
    return null;
  }

  // Xóa session (logout)
  static Future<void> clearSession() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Kiểm tra có session hay không
  static Future<bool> hasSession() async {
    final session = await getSession();
    return session != null;
  }
}

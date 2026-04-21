import '../models/user.dart';
import '../utils/database_helper.dart';
import '../utils/session_manager.dart';

class AuthController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<User?> login(String email, String password, bool rememberMe) async {
    if (email.trim().isEmpty || password.trim().isEmpty) return null;
    final user = await _dbHelper.login(email.trim(), password);
    if (user != null && rememberMe) {
      await SessionManager.saveSession(email.trim(), password);
    }
    return user;
  }

  Future<User?> autoLogin() async {
    final session = await SessionManager.getSession();
    if (session != null) {
      return await _dbHelper.login(session['email']!, session['password']!);
    }
    return null;
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
  }
}

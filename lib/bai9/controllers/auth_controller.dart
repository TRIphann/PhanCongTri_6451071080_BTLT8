import '../models/user.dart';
import '../utils/database_helper.dart';

class AuthController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<User?> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) return null;
    return await _dbHelper.login(email.trim(), password);
  }
}

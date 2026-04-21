import '../models/category.dart';
import '../utils/database_helper.dart';

class CategoryController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Category>> getAllCategories() async {
    return await _dbHelper.getAllCategories();
  }

  Future<bool> addCategory(String name) async {
    if (name.trim().isEmpty) return false;
    final cat = Category(name: name.trim());
    final id = await _dbHelper.insertCategory(cat);
    return id > 0;
  }

  Future<bool> deleteCategory(int id) async {
    final result = await _dbHelper.deleteCategory(id);
    return result > 0;
  }
}

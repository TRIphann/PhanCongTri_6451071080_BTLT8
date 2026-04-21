import '../models/category.dart';
import '../utils/database_helper.dart';

class CategoryController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Lấy tất cả danh mục
  Future<List<Category>> getAllCategories() async {
    return await _dbHelper.getAllCategories();
  }

  // Thêm danh mục mới
  Future<bool> addCategory(String name) async {
    if (name.trim().isEmpty) return false;
    final category = Category(name: name.trim());
    final id = await _dbHelper.insertCategory(category);
    return id > 0;
  }

  // Xóa danh mục
  Future<bool> deleteCategory(int id) async {
    final result = await _dbHelper.deleteCategory(id);
    return result > 0;
  }
}

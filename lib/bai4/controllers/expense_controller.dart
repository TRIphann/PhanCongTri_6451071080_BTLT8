import '../models/expense.dart';
import '../models/category.dart';
import '../utils/database_helper.dart';

class ExpenseController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Expense>> getAllExpenses() async {
    return await _dbHelper.getAllExpenses();
  }

  Future<bool> addExpense(double amount, String note, int categoryId) async {
    if (note.trim().isEmpty || amount <= 0) return false;
    final expense = Expense(amount: amount, note: note.trim(), categoryId: categoryId);
    final id = await _dbHelper.insertExpense(expense);
    return id > 0;
  }

  Future<bool> updateExpense(int id, double amount, String note, int categoryId) async {
    if (note.trim().isEmpty || amount <= 0) return false;
    final expense = Expense(id: id, amount: amount, note: note.trim(), categoryId: categoryId);
    final result = await _dbHelper.updateExpense(expense);
    return result > 0;
  }

  Future<bool> deleteExpense(int id) async {
    final result = await _dbHelper.deleteExpense(id);
    return result > 0;
  }

  Future<List<Category>> getAllCategories() async {
    return await _dbHelper.getAllCategories();
  }

  Future<List<Map<String, dynamic>>> getTotalByCategory() async {
    return await _dbHelper.getTotalByCategory();
  }
}

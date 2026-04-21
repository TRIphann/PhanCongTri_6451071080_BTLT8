import '../models/note.dart';
import '../utils/database_helper.dart';

class NoteController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Lấy tất cả ghi chú
  Future<List<Note>> getAllNotes() async {
    return await _dbHelper.getAllNotes();
  }

  // Lấy ghi chú theo id
  Future<Note?> getNoteById(int id) async {
    return await _dbHelper.getNoteById(id);
  }

  // Thêm ghi chú mới
  Future<bool> addNote(String title, String content) async {
    if (title.trim().isEmpty) return false;
    final note = Note(title: title.trim(), content: content.trim());
    final id = await _dbHelper.insertNote(note);
    return id > 0;
  }

  // Cập nhật ghi chú
  Future<bool> updateNote(int id, String title, String content) async {
    if (title.trim().isEmpty) return false;
    final note = Note(id: id, title: title.trim(), content: content.trim());
    final result = await _dbHelper.updateNote(note);
    return result > 0;
  }

  // Xóa ghi chú
  Future<bool> deleteNote(int id) async {
    final result = await _dbHelper.deleteNote(id);
    return result > 0;
  }
}

import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../controllers/category_controller.dart';
import '../models/note.dart';
import '../models/category.dart';
import '../widgets/category_dropdown.dart';

class NoteFormView extends StatefulWidget {
  final Note? note; // null = thêm mới, có giá trị = chỉnh sửa

  const NoteFormView({super.key, this.note});

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteController = NoteController();
  final _categoryController = CategoryController();

  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = true;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryController.getAllCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
      // Nếu đang chỉnh sửa, chọn danh mục hiện tại
      if (isEditing) {
        _selectedCategory = categories.firstWhere(
          (c) => c.id == widget.note!.categoryId,
          orElse: () => categories.first,
        );
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;

    bool success;
    if (isEditing) {
      success = await _noteController.updateNote(
        widget.note!.id!,
        _titleController.text,
        _contentController.text,
        _selectedCategory!.id!,
      );
    } else {
      success = await _noteController.addNote(
        _titleController.text,
        _contentController.text,
        _selectedCategory!.id!,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Đã cập nhật ghi chú!' : 'Đã thêm ghi chú mới!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa ghi chú' : 'Thêm ghi chú mới'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dropdown chọn danh mục
                    CategoryDropdown(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onChanged: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Tiêu đề',
                        hintText: 'Nhập tiêu đề ghi chú...',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập tiêu đề';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Content field
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Nội dung',
                        hintText: 'Nhập nội dung ghi chú...',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      maxLines: 8,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập nội dung';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Save button
                    ElevatedButton.icon(
                      onPressed: _saveNote,
                      icon: const Icon(Icons.save),
                      label: Text(
                        isEditing ? 'Cập nhật' : 'Lưu ghi chú',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

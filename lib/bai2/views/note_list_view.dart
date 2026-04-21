import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../controllers/category_controller.dart';
import '../models/note.dart';
import '../models/category.dart';
import '../widgets/note_card.dart';
import 'note_form_view.dart';
import 'category_form_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final _noteController = NoteController();
  final _categoryController = CategoryController();

  List<Note> _notes = [];
  List<Category> _categories = [];
  Category? _selectedFilter; // null = hiển thị tất cả
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final categories = await _categoryController.getAllCategories();
    List<Note> notes;
    if (_selectedFilter != null) {
      notes = await _noteController.getNotesByCategory(_selectedFilter!.id!);
    } else {
      notes = await _noteController.getAllNotes();
    }
    setState(() {
      _categories = categories;
      _notes = notes;
      _isLoading = false;
    });
  }

  // Xóa ghi chú với dialog xác nhận
  Future<void> _deleteNote(Note note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa ghi chú "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _noteController.deleteNote(note.id!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa ghi chú!'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadData();
      }
    }
  }

  // Chuyển sang màn hình thêm/sửa ghi chú
  Future<void> _navigateToNoteForm({Note? note}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => NoteFormView(note: note)),
    );
    if (result == true) {
      _loadData();
    }
  }

  // Chuyển sang màn hình thêm danh mục
  Future<void> _navigateToCategoryForm() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CategoryFormView()),
    );
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Ghi chú theo danh mục'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Nút thêm danh mục
          IconButton(
            onPressed: _navigateToCategoryForm,
            icon: const Icon(Icons.create_new_folder),
            tooltip: 'Thêm danh mục',
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh filter theo danh mục
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.teal[50],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Nút "Tất cả"
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('Tất cả'),
                      selected: _selectedFilter == null,
                      selectedColor: Colors.teal[200],
                      onSelected: (selected) {
                        setState(() => _selectedFilter = null);
                        _loadData();
                      },
                    ),
                  ),
                  // Các nút filter theo danh mục
                  ..._categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category.name),
                        selected: _selectedFilter?.id == category.id,
                        selectedColor: Colors.teal[200],
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = selected ? category : null;
                          });
                          _loadData();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Danh sách ghi chú
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter != null
                              ? 'Không có ghi chú trong danh mục này'
                              : 'Chưa có ghi chú nào',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nhấn nút + để thêm ghi chú mới',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return NoteCard(
                        note: note,
                        onTap: () => _navigateToNoteForm(note: note),
                        onDelete: () => _deleteNote(note),
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Text(
              'Phan Công Trí - 6451071080',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNoteForm(),
        backgroundColor: Colors.teal[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

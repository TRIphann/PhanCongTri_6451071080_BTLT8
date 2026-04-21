import 'package:flutter/material.dart';
import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseFormView extends StatefulWidget {
  final Expense? expense;
  const ExpenseFormView({super.key, this.expense});

  @override
  State<ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<ExpenseFormView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _controller = ExpenseController();
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = false;

  bool get isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (isEditing) {
      _amountController.text = widget.expense!.amount.toStringAsFixed(0);
      _noteController.text = widget.expense!.note;
    }
  }

  Future<void> _loadCategories() async {
    final cats = await _controller.getAllCategories();
    setState(() {
      _categories = cats;
      if (isEditing) {
        _selectedCategory = cats.firstWhere((c) => c.id == widget.expense!.categoryId, orElse: () => cats.first);
      } else if (cats.isNotEmpty) {
        _selectedCategory = cats.first;
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) return;
    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0;
    bool success;
    if (isEditing) {
      success = await _controller.updateExpense(widget.expense!.id!, amount, _noteController.text, _selectedCategory!.id!);
    } else {
      success = await _controller.addExpense(amount, _noteController.text, _selectedCategory!.id!);
    }

    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Đã cập nhật!' : 'Đã thêm chi tiêu!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa chi tiêu' : 'Thêm chi tiêu'),
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Số tiền (VNĐ)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Vui lòng nhập số tiền';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Số tiền không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập ghi chú' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Danh mục',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? 'Vui lòng chọn danh mục' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save),
                label: Text(isEditing ? 'Cập nhật' : 'Lưu chi tiêu', style: const TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

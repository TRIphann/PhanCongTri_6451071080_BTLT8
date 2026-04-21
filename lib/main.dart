import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'bai1/views/note_list_view.dart' as bai1;
import 'bai2/views/note_list_view.dart' as bai2;
import 'bai3/views/task_list_view.dart' as bai3;
import 'bai4/views/expense_list_view.dart' as bai4;
import 'bai5/views/dictionary_view.dart' as bai5;
import 'bai6/views/gallery_view.dart' as bai6;
import 'bai7/views/student_list_view.dart' as bai7;
import 'bai8_log/views/item_list_view.dart' as bai8;
import 'bai9/views/login_view.dart' as bai9;
import 'bai10/views/splash_view.dart' as bai10;

void main() {
  if (kIsWeb) {
    // Sử dụng sqflite_common_ffi_web cho nền tảng web
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buổi 8 - Lập trình di động',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = [
      _ExerciseInfo(
        title: 'Bài 1',
        subtitle: 'Ghi chú cơ bản (SQLite CRUD)',
        icon: Icons.note_alt,
        color: Colors.blue,
        page: const bai1.NoteListView(),
      ),
      _ExerciseInfo(
        title: 'Bài 2',
        subtitle: 'Ghi chú có danh mục (Khóa ngoại)',
        icon: Icons.category,
        color: Colors.teal,
        page: const bai2.NoteListView(),
      ),
      _ExerciseInfo(
        title: 'Bài 3',
        subtitle: 'To-Do List + Backup JSON',
        icon: Icons.checklist,
        color: Colors.green,
        page: const bai3.TaskListView(),
      ),
      _ExerciseInfo(
        title: 'Bài 4',
        subtitle: 'Quản lý chi tiêu (Nhiều bảng)',
        icon: Icons.payments,
        color: Colors.orange,
        page: const bai4.ExpenseListView(),
      ),
      _ExerciseInfo(
        title: 'Bài 5',
        subtitle: 'Từ điển offline (JSON + SQLite)',
        icon: Icons.book,
        color: Colors.purple,
        page: const bai5.DictionaryView(),
      ),
      _ExerciseInfo(
        title: 'Bài 6',
        subtitle: 'Thư viện ảnh offline (File + SQLite)',
        icon: Icons.photo_library,
        color: Colors.pink,
        page: const bai6.GalleryView(),
      ),
      _ExerciseInfo(
        title: 'Bài 7',
        subtitle: 'Quản lý SV - Môn học (N-N)',
        icon: Icons.school,
        color: Colors.cyan,
        page: const bai7.StudentListView(),
      ),
      _ExerciseInfo(
        title: 'Bài 8',
        subtitle: 'Nhật ký hoạt động (SQLite + File log)',
        icon: Icons.history,
        color: Colors.brown,
        page: const bai8.ItemListView(),
      ),
      _ExerciseInfo(
        title: 'Bài 9',
        subtitle: 'Login form + kiểm tra SQLite',
        icon: Icons.login,
        color: Colors.indigo,
        page: const bai9.LoginView(),
      ),
      _ExerciseInfo(
        title: 'Bài 10',
        subtitle: 'Login + Remember Me (File + SQLite)',
        icon: Icons.fingerprint,
        color: Colors.deepPurple,
        page: const bai10.SplashView(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('📱 Buổi 8 - SQLite'),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final e = exercises[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => e.page),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: e.color.withValues(alpha: 0.1),
                        child: Icon(e.icon, size: 24, color: e.color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: e.color,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              e.subtitle,
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExerciseInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  _ExerciseInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });
}

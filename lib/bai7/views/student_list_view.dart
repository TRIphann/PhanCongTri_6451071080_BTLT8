import 'package:flutter/material.dart';
import '../controllers/student_controller.dart';
import '../models/student.dart';
import '../models/course.dart';
import 'enrollment_view.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView>
    with SingleTickerProviderStateMixin {
  final _controller = StudentController();
  late TabController _tabController;
  List<Student> _students = [];
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final students = await _controller.getAllStudents();
    final courses = await _controller.getAllCourses();
    setState(() {
      _students = students;
      _courses = courses;
      _isLoading = false;
    });
  }

  Future<void> _addStudent() async {
    final nameCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm sinh viên'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: 'Nhập tên sinh viên...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    if (result == true && nameCtrl.text.trim().isNotEmpty) {
      await _controller.addStudent(nameCtrl.text);
      _loadData();
    }
    nameCtrl.dispose();
  }

  Future<void> _addCourse() async {
    final nameCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm môn học'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: 'Nhập tên môn học...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
    if (result == true && nameCtrl.text.trim().isNotEmpty) {
      await _controller.addCourse(nameCtrl.text);
      _loadData();
    }
    nameCtrl.dispose();
  }

  Future<void> _deleteStudent(Student s) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa sinh viên "${s.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _controller.deleteStudent(s.id!);
      _loadData();
    }
  }

  Future<void> _openEnrollment(Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EnrollmentView(student: student)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎓 Quản lý SV - Môn học'),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Sinh viên'),
            Tab(icon: Icon(Icons.book), text: 'Môn học'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab Sinh viên
                      _students.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 80,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Chưa có sinh viên',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _students.length,
                              itemBuilder: (context, index) {
                                final s = _students[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.cyan[100],
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.cyan[700],
                                      ),
                                    ),
                                    title: Text(
                                      s.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: FutureBuilder<List<Course>>(
                                      future: _controller.getCoursesForStudent(
                                        s.id!,
                                      ),
                                      builder: (ctx, snapshot) {
                                        if (!snapshot.hasData)
                                          return const Text('...');
                                        if (snapshot.data!.isEmpty)
                                          return const Text(
                                            'Chưa đăng ký môn nào',
                                          );
                                        return Text(
                                          snapshot.data!
                                              .map((c) => c.name)
                                              .join(', '),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.app_registration,
                                            color: Colors.cyan[700],
                                          ),
                                          tooltip: 'Đăng ký môn',
                                          onPressed: () => _openEnrollment(s),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          onPressed: () => _deleteStudent(s),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                      // Tab Môn học
                      _courses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book_outlined,
                                    size: 80,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Chưa có môn học',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _courses.length,
                              itemBuilder: (context, index) {
                                final c = _courses[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.amber[100],
                                      child: Icon(
                                        Icons.book,
                                        color: Colors.amber[800],
                                      ),
                                    ),
                                    title: Text(
                                      c.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
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
        onPressed: () {
          if (_tabController.index == 0) {
            _addStudent();
          } else {
            _addCourse();
          }
        },
        backgroundColor: Colors.cyan[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

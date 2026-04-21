import 'package:flutter/material.dart';
import '../controllers/student_controller.dart';
import '../models/student.dart';
import '../models/course.dart';

class EnrollmentView extends StatefulWidget {
  final Student student;
  const EnrollmentView({super.key, required this.student});

  @override
  State<EnrollmentView> createState() => _EnrollmentViewState();
}

class _EnrollmentViewState extends State<EnrollmentView> {
  final _controller = StudentController();
  List<Course> _allCourses = [];
  List<int> _enrolledIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final courses = await _controller.getAllCourses();
    final enrolledIds = await _controller.getEnrolledCourseIds(widget.student.id!);
    setState(() {
      _allCourses = courses;
      _enrolledIds = enrolledIds;
      _isLoading = false;
    });
  }

  Future<void> _toggleEnrollment(Course course) async {
    final isEnrolled = _enrolledIds.contains(course.id);
    if (isEnrolled) {
      await _controller.unenroll(widget.student.id!, course.id!);
    } else {
      await _controller.enroll(widget.student.id!, course.id!);
    }
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký: ${widget.student.name}'),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allCourses.isEmpty
              ? Center(
                  child: Text('Chưa có môn học nào', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.cyan[50],
                      child: Text(
                        'Đã đăng ký: ${_enrolledIds.length}/${_allCourses.length} môn',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan[700]),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _allCourses.length,
                        itemBuilder: (context, index) {
                          final course = _allCourses[index];
                          final isEnrolled = _enrolledIds.contains(course.id);
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: CheckboxListTile(
                              value: isEnrolled,
                              onChanged: (_) => _toggleEnrollment(course),
                              title: Text(
                                course.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isEnrolled ? Colors.cyan[700] : null,
                                ),
                              ),
                              secondary: Icon(
                                isEnrolled ? Icons.check_circle : Icons.circle_outlined,
                                color: isEnrolled ? Colors.cyan[700] : Colors.grey,
                              ),
                              activeColor: Colors.cyan[700],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

import 'package:flutter/material.dart';
import '../views/student_list_view.dart';

class Bai7App extends StatelessWidget {
  const Bai7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 7 - Quản lý SV - Môn học',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.cyan, useMaterial3: true),
      home: const StudentListView(),
    );
  }
}

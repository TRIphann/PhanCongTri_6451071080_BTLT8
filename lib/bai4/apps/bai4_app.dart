import 'package:flutter/material.dart';
import '../views/expense_list_view.dart';

class Bai4App extends StatelessWidget {
  const Bai4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 4 - Quản lý chi tiêu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.orange, useMaterial3: true),
      home: const ExpenseListView(),
    );
  }
}

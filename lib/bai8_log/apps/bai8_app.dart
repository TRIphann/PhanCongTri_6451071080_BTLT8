import 'package:flutter/material.dart';
import '../views/item_list_view.dart';

class Bai8App extends StatelessWidget {
  const Bai8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 8 - Nhật ký hoạt động',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
      home: const ItemListView(),
    );
  }
}

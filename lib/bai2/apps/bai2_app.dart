import 'package:flutter/material.dart';
import '../views/note_list_view.dart';

class Bai2App extends StatelessWidget {
  const Bai2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 2 - Ghi chú có danh mục',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const NoteListView(),
    );
  }
}

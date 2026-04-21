import 'package:flutter/material.dart';
import '../views/note_list_view.dart';

class Bai1App extends StatelessWidget {
  const Bai1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 1 - Ghi chú cơ bản',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const NoteListView(),
    );
  }
}

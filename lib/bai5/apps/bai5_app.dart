import 'package:flutter/material.dart';
import '../views/dictionary_view.dart';

class Bai5App extends StatelessWidget {
  const Bai5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 5 - Từ điển offline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
      home: const DictionaryView(),
    );
  }
}

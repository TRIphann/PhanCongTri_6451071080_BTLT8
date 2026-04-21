import 'package:flutter/material.dart';
import '../views/gallery_view.dart';

class Bai6App extends StatelessWidget {
  const Bai6App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 6 - Thư viện ảnh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.pink, useMaterial3: true),
      home: const GalleryView(),
    );
  }
}

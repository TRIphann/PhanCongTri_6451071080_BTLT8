import 'package:flutter/material.dart';
import '../views/login_view.dart';

class Bai9App extends StatelessWidget {
  const Bai9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 9 - Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const LoginView(),
    );
  }
}

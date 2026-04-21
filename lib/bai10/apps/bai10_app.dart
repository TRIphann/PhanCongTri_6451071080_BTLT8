import 'package:flutter/material.dart';
import '../views/splash_view.dart';

class Bai10App extends StatelessWidget {
  const Bai10App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 10 - Login + Remember Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const SplashView(),
    );
  }
}

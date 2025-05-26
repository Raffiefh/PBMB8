import 'package:flutter/material.dart';
import 'package:pbmuas/screens/splash_screen.dart';
import 'screens/screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EHO : Event Horeg Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

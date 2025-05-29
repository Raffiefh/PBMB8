import 'dart:async';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'base.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const sign_in()),
    );
  }

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return BaseScaffold(
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.08),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/EHO.png',
              width: size.width * 0.45,
              height: size.height * 0.45,
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: _goToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 12, 142, 218),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.015,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 8,
                shadowColor: Colors.blue.shade700,
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
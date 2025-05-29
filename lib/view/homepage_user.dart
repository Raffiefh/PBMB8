import 'package:flutter/material.dart';

class HomepageUser extends StatelessWidget {
  const HomepageUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Ini Halaman Beranda",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

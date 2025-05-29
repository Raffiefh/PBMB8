import 'package:flutter/material.dart';

class PanitiaScreen extends StatelessWidget {
  const PanitiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panitia Dashboard")),
      body: const Center(child: Text("Selamat datang, Panitia!")),
    );
  }
}

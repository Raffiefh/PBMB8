import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;

  const BaseScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,  // atau Alignment(0, -1)
          end: Alignment.bottomCenter, // atau Alignment(0, 1)
          colors: [
            Color.fromRGBO(209, 223, 255, 1),  // #d1dfff di 0%
            Color.fromRGBO(153, 209, 255, 1),  // 25%
            Color.fromRGBO(102, 186, 255, 1),  // 56%
            Color.fromRGBO(69, 177, 255, 1),   // 100%
          ],
          stops: [0.0, 0.25, 0.56, 1.0],  // posisi warna sesuai persentase CSS
        ),
      ),
      child: SafeArea(child: child),
    ),
  );
}
}
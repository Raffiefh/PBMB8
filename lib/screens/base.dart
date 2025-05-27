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
          begin: Alignment.topCenter,  
          end: Alignment.bottomCenter, 
          colors: [
            Color.fromRGBO(209, 223, 255, 1), 
            Color.fromRGBO(153, 209, 255, 1),  
            Color.fromRGBO(102, 186, 255, 1),  
            Color.fromRGBO(69, 177, 255, 1),
          ],
          stops: [0.0, 0.25, 0.56, 1.0],  
        ),
      ),
      child: SafeArea(child: child),
    ),
  );
}
}
// lib/widgets/custom_flushbar_widget.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushbar {
  static void show(
    BuildContext context, {
    required String message,
    required bool isSuccess,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    Color bgColor = isSuccess ? const Color.fromARGB(255, 48, 187, 53) : Colors.redAccent;
    IconData icon = isSuccess ? Icons.check_circle_outline : Icons.error_outline;

    Flushbar(
      messageText: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
      duration: duration,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(10),
      animationDuration: const Duration(milliseconds: 3000),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }
}
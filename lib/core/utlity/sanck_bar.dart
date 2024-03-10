import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar buildSnackBar(
      {required String message, required Color color}) {
    return SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
  }
}

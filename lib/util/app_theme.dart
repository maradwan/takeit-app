import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);

  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );
}

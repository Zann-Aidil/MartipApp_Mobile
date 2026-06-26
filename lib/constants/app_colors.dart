import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF5C4DB1);
  static const Color primaryLight = Color(0xFF7E68D4);
  static const Color primaryDark = Color(0xFF3D2E7A);

  // Secondary Colors
  static const Color secondary = Color(0xFF231F20);
  static const Color secondaryLight = Color(0xFF4A4647);
  static const Color secondaryDark = Color(0xFF0F0D0E);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color lightGreyAlt = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFE0E0E0);

  // Transparency
  static Color primaryOverlay = primary.withOpacity(0.1);
  static Color errorOverlay = error.withOpacity(0.1);
  static Color successOverlay = success.withOpacity(0.1);
}

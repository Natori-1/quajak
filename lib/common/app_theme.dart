
import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFFFF8F5);
  static const brown = Color(0xFFAD7858);
  static const cream = Color(0xFFF9E9DC);
  static const dark = Color(0xFF49372F);
  static const gray = Color(0xFFB7AAA3);
  static const pink = Color(0xFFFFE5E3);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brown,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.dark,
        elevation: 0,
      ),
    );
  }
}

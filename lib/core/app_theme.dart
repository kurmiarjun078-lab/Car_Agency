import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  AppFonts._();
  static const String poppins = 'Poppins';
  static const String inter = 'Inter';
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.black,
          brightness: Brightness.light,
        ).copyWith(primary: AppColors.black, surface: Colors.white),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.black,
        ),
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
      );
}

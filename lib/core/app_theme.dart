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
        fontFamily: AppFonts.poppins,
        scaffoldBackgroundColor: AppColors.bgHome,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.black,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.black,
          secondary: AppColors.blue,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          titleTextStyle: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return const Color(0xFFB5B7BC);
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.black;
            }
            return AppColors.borderLight;
          }),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.black,
        ),
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
      );
}

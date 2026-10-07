import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/auth/splash_screen.dart';

void main() => runApp(const DriveHubApp());

class DriveHubApp extends StatelessWidget {
  const DriveHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Keeps layouts overflow-safe when users crank up system font size.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.15,
            ),
          ),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

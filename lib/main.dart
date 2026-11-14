
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'core/app_theme.dart';
import 'services/auth_service.dart';
import 'screens/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AuthService.instance.init();
  runApp(const DriveHubApp());
}

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

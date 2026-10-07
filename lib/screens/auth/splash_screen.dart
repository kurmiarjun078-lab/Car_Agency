import 'dart:async';

import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 2),
      _nextScreen,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _nextScreen() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF888888),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            children: [
              SizedBox(height: 55),

              // DriveHub
              Text(
                'DriveHub',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171717),
                ),
              ),

              Spacer(),

              // Loading indicator
              SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF444444),
                  ),
                ),
              ),

              SizedBox(height: 12),

              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Spacer(),

              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

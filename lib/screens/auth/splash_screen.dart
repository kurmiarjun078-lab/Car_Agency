import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
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
    _timer = Timer(const Duration(milliseconds: 2500), _next);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _next() {
    if (!mounted) return;
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOnboarding,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _next,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FB),
                Color(0xFFE9EBEE),
                Color(0xFFF3F4F6),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const Text(
                    'DriveHub',
                    style: TextStyle(
                      fontSize: 58,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.8,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Luxury mobility, reimagined.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      color: Color(0xFF5E6470),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFAFAFB),
                          Color(0xFFE8E9EE),
                        ],
                      ),
                      border: Border.all(color: const Color(0xFFE3E4E8), width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1C000000),
                          blurRadius: 24,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 24,
                          left: 24,
                          child: Container(
                            width: 118,
                            height: 118,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFDBDEE4).withOpacity(0.7),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 18,
                          right: 18,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFCFD5DE).withOpacity(0.35),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.directions_car_filled_rounded,
                          size: 116,
                          color: Color(0xFF1B1D23),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  const _PearlIndicator(),
                  const SizedBox(height: 18),
                  const Text(
                    'Preparing your next drive',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The glossy round "pearl" at the bottom of the splash design.
class _PearlIndicator extends StatelessWidget {
  const _PearlIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFF4F4F5), Color(0xFFCBCBCF)],
        ),
        border: Border.all(color: const Color(0xFFE9E9EB), width: 3),
        boxShadow: const [
          BoxShadow(
              color: Color(0x22000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE2E2E5), Color(0xFFF3F3F4)],
          ),
          border: Border.all(color: const Color(0xFFD5D5D9), width: 2),
        ),
      ),
    );
  }
}

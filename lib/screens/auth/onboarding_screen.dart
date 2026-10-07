import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'login_screen.dart';

class _OnboardingPageData {
  const _OnboardingPageData(this.title, this.body);
  final String title;
  final String body;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Page 1 text is from the Figma. Pages 2 and 3 are placeholder copy
  // (only the first onboarding screen was exported).
  static const _pages = [
    _OnboardingPageData(
      'Find your dream car',
      'Browse a curated collection of luxury vehicles to match your lifestyle',
    ),
    _OnboardingPageData(
      'Book in minutes',
      'Schedule test drives and reserve your favourite car in a few taps',
    ),
  ];

  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;
    return Scaffold(
      backgroundColor: AppColors.bgOnboarding,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              const Text(
                'DriveHub',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 62,
                width: double.infinity,
                child: Material(
                  color: Colors.white,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: _next,
                    child: Center(
                      child: Text(
                        isLast ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < _pages.length; i++)
                      Container(
                        width: 11,
                        height: 11,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _index
                              ? Colors.black
                              : const Color(0xFF5A5A5A),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: c.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Illustration area. The Figma shows a very faint car here.
              // TODO: replace with your onboarding illustration asset.
              SizedBox(
                height: (c.maxHeight * 0.45).clamp(0.0, 320.0).toDouble(),
                child: const Center(
                  child: Icon(
                    Icons.directions_car_filled_rounded,
                    size: 120,
                    color: Color(0x0F000000),
                  ),
                ),
              ),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                data.body,
                style: const TextStyle(fontSize: 20, height: 1.25),
              ),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../widgets/car_image.dart';
import '../auth/login_screen.dart';
import 'service_booking_screen.dart';
import 'wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _soon(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$label (not designed yet)')));
  }

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      
      _MenuItem(Icons.favorite_border, 'Wishlist',
          () => pushScreen(context, const WishlistScreen())),
      _MenuItem(Icons.calendar_today_outlined, 'My Bookings',
          () => pushScreen(
                context,
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                  ),
                  body: const ServiceBookingScreen(),
                ),
              )),
    
      _MenuItem(Icons.settings_outlined, 'Settings',
          () => _soon(context, 'Settings')),
      _MenuItem(Icons.logout, 'Logout',
          () => replaceAll(context, const LoginScreen())),
    ];

    return Container(
      color: AppColors.bgProfile,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            children: [
              
              const Avatar(size: 112, asset: 'assets/avatars/bishal.png', ring: true),
              const SizedBox(height: 16),
              const Text(
                'Bishal Thapa',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3C3E45),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'bishal.thapa@drivehub.com',
                style: TextStyle(fontSize: 17, color: Color(0xFF4A4C53)),
              ),
              const Text(
                '+917 980000000',
                style: TextStyle(fontSize: 17, color: Color(0xFF4A4C53)),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  children: [
                    for (final item in items)
                      InkWell(
                        onTap: item.onTap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Icon(item.icon,
                                  size: 28, color: const Color(0xFF4A4C53)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  size: 28, color: AppColors.textGrey),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

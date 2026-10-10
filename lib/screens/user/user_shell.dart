import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/app_bottom_nav.dart';
import 'browse_cars_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'service_booking_screen.dart';
import 'wishlist_screen.dart';

/// Main app frame with the 5-tab bottom bar from the Home design.
class UserShell extends StatefulWidget {
  const UserShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  late int _index = widget.initialIndex;

  static const _items = [
    NavItemData(Icons.home_outlined, 'Home', activeIcon: Icons.home_filled),
    NavItemData(Icons.directions_car_outlined, 'Cars',
        activeIcon: Icons.directions_car_filled),
    NavItemData(Icons.calendar_today_outlined, 'Bookings',
        activeIcon: Icons.calendar_month),
    NavItemData(Icons.favorite_border, 'Wishlist', activeIcon: Icons.favorite),
    NavItemData(Icons.person_outline, 'Profile', activeIcon: Icons.person),
  ];

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final onCarsTab = _index == 1;
    return Scaffold(
      backgroundColor: _index == 0 ? AppColors.bgHome : Colors.white,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onNavigate: _select),
          const BrowseCarsScreen(),
          const ServiceBookingScreen(),
          WishlistScreen(onBack: () => _select(0)),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: _items,
        currentIndex: _index,
        onTap: _select,
        activeColor: onCarsTab ? AppColors.blue : AppColors.black,
        showTopIndicator: onCarsTab,
      ),
    );
  }
}

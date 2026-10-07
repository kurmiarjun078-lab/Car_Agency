import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../widgets/app_bottom_nav.dart';
import '../auth/login_screen.dart';
import 'admin_add_car_screen.dart';
import 'admin_customers_screen.dart';
import 'admin_dashboard_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _items = [
    NavItemData(Icons.space_dashboard_outlined, 'Dashboard',
        activeIcon: Icons.space_dashboard),
    NavItemData(Icons.directions_car, 'Cars'),
    NavItemData(Icons.calendar_month, 'Bookings'),
    NavItemData(Icons.groups, 'Customers'),
    NavItemData(Icons.more_horiz, 'More'),
  ];

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _index,
        children: [
          const AdminDashboardScreen(),
          // "Cars" tab opens the Add New Car form (the only car screen designed).
          AdminAddCarScreen(onBack: () => _select(0)),
          // Bookings has no design yet.
          const _PlaceholderTab(title: 'Bookings'),
          const AdminCustomersScreen(),
          _MoreTab(onLogout: () => replaceAll(context, const LoginScreen())),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: _items,
        currentIndex: _index,
        onTap: _select,
        activeColor: AppColors.black,
        inactiveColor: const Color(0xFF8E8E93),
        backgroundColor: const Color(0xFFF7F7F9),
        boldActiveLabel: true,
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          '$title screen not designed yet',
          style: const TextStyle(fontSize: 18, color: AppColors.textGrey),
        ),
      ),
    );
  }
}

class _MoreTab extends StatelessWidget {
  const _MoreTab({required this.onLogout});
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
        ),
      ),
    );
  }
}

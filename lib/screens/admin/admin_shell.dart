import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../widgets/app_bottom_nav.dart';
import '../auth/login_screen.dart';
import 'admin_add_car_screen.dart';
import 'admin_bookings_screen.dart';
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
          const AdminBookingsScreen(),
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

class _MoreTab extends StatelessWidget {
  const _MoreTab({required this.onLogout});
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgAdmin,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          children: [
            const Text(
              'MORE',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.only(left: 6, bottom: 10),
              child: Text(
                'Account',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted),
              ),
            ),
            _MoreCard(
              children: [
                _MoreTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Admin profile',
                  subtitle: 'View account and access information',
                  onTap: () => _showPanel(
                    context,
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Admin profile',
                    children: const [
                      _InfoRow(label: 'Account', value: 'DriveHub Admin'),
                      _InfoRow(label: 'Role', value: 'Administrator'),
                      _InfoRow(
                          label: 'Access',
                          value: 'Cars, bookings and customers'),
                    ],
                  ),
                ),
                _MoreTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'App information and preferences',
                  onTap: () => _showPanel(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    children: const [
                      _InfoRow(label: 'App', value: 'DriveHub'),
                      _InfoRow(label: 'Version', value: '1.0.0'),
                      _InfoRow(label: 'Appearance', value: 'Light'),
                    ],
                  ),
                ),
                _MoreTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  subtitle: 'Get help using the admin dashboard',
                  onTap: () => _showPanel(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: 'Help & support',
                    children: const [
                      _InfoRow(
                        label: 'Manage cars',
                        value: 'Use the Cars tab to add a vehicle.',
                      ),
                      _InfoRow(
                        label: 'Bookings',
                        value: 'Review and filter reservations in Bookings.',
                      ),
                      _InfoRow(
                        label: 'Customers',
                        value: 'Search customer records in Customers.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.only(left: 6, bottom: 10),
              child: Text(
                'Session',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted),
              ),
            ),
            _MoreCard(
              children: [
                _MoreTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out of the admin account',
                  isDestructive: true,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPanel(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(icon, color: AppColors.black),
                  const SizedBox(width: 10),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will be returned to the login screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.black),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (shouldLogout == true && context.mounted) onLogout();
  }
}

class _MoreCard extends StatelessWidget {
  const _MoreCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: Column(children: children),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final foreground =
        isDestructive ? const Color(0xFFB3261E) : AppColors.black;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      leading: Icon(icon, color: foreground, size: 25),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.w600, color: foreground)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
      trailing: isDestructive
          ? null
          : const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 94,
            child:
                Text(label, style: const TextStyle(color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

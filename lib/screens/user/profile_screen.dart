import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../data/models.dart';
import '../../data/profile_store.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/car_image.dart';
import '../auth/login_screen.dart';
import 'my_bookings_screen.dart';
import 'settings_screen.dart';
import 'wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(Icons.favorite_border, 'Wishlist',
          () => pushScreen(context, const WishlistScreen())),
      _MenuItem(
        Icons.calendar_today_outlined,
        'My Bookings',
        () => pushScreen(context, const MyBookingsScreen(showBack: true)),
      ),
      _MenuItem(Icons.settings_outlined, 'Settings',
          () => pushScreen(context, const SettingsScreen())),
      _MenuItem(Icons.logout, 'Logout', () async {
        if (!await confirmLogout(context)) return;
        await AuthService.instance.logout();
        if (context.mounted) replaceAll(context, const LoginScreen());
      }),
    ];

    return Container(
      color: AppColors.bgProfile,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            children: [
              ValueListenableBuilder<AppUser?>(
                valueListenable: ProfileStore.user,
                builder: (context, profile, _) {
                  final auth = AuthService.instance.currentUser;
                  var name = profile?.name ?? '';
                  if (name.isEmpty) name = auth?.displayName ?? '';
                  final email = (profile?.email.isNotEmpty ?? false)
                      ? profile!.email
                      : (auth?.email ?? '');
                  final phone = profile?.phone ?? '';
                  return Column(
                    children: [
                      Avatar(
                        size: 112,
                        name: name,
                        photo: profile?.photo,
                        ring: true,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name.isEmpty ? 'DriveHub User' : name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3C3E45),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: const TextStyle(
                            fontSize: 17, color: Color(0xFF4A4C53)),
                      ),
                      if (phone.isNotEmpty)
                        Text(
                          phone,
                          style: const TextStyle(
                              fontSize: 17, color: Color(0xFF4A4C53)),
                        ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => showEditProfileDialog(context),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit profile'),
                      ),
                    ],
                  );
                },
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

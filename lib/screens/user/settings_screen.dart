import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _biometricLogin = true;
  bool _locationAccess = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgProfile,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(title: 'Account'),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal details',
                    subtitle: 'Manage your account profile',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textGrey),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Security',
                    subtitle: 'Password and sign-in settings',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textGrey),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _SectionHeader(title: 'Preferences'),
              _SettingsCard(
                children: [
                  _SwitchTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Push notifications',
                    subtitle: 'Receive updates and offers',
                    value: _pushNotifications,
                    onChanged: (value) => setState(() => _pushNotifications = value),
                  ),
                  _SwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark mode',
                    subtitle: 'Use a dark interface',
                    value: _darkMode,
                    onChanged: (value) => setState(() => _darkMode = value),
                  ),
                  _SwitchTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric login',
                    subtitle: 'Use Face ID or fingerprint',
                    value: _biometricLogin,
                    onChanged: (value) => setState(() => _biometricLogin = value),
                  ),
                  _SwitchTile(
                    icon: Icons.location_on_outlined,
                    title: 'Location access',
                    subtitle: 'For nearby offers and service alerts',
                    value: _locationAccess,
                    onChanged: (value) => setState(() => _locationAccess = value),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _SectionHeader(title: 'Support'),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help center',
                    subtitle: 'Find answers to common questions',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textGrey),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'Contact support',
                    subtitle: 'Talk to our customer care team',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textGrey),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy policy',
                    subtitle: 'Read our data handling policy',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textGrey),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.iconTile,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.black, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.iconTile,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.black, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

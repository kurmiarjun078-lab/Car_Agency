import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../services/auth_service.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/primary_button.dart';
import '../admin/admin_shell.dart';
import '../user/user_shell.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.adminOnly = false});

  final bool adminOnly;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _loading = false;

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      _toast('Enter your email and password.');
      return;
    }

    setState(() => _loading = true);
    try {
      final role = await AuthService.instance
          .login(_email.text, _password.text);
      if (!mounted) return;
      final expectedRole = widget.adminOnly ? 'admin' : 'user';
      if (role != expectedRole) {
        await AuthService.instance.logout();
        if (mounted) {
          _toast(
            widget.adminOnly
                ? 'This account does not have admin access.'
                : 'This is an admin account. Use Admin Login.',
          );
        }
        return;
      }
      replaceAll(
        context,
        role == 'admin' ? const AdminShell() : const UserShell(),
      );
    } catch (e) {
      if (mounted) _toast(AuthService.friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final topGap = MediaQuery.sizeOf(context).height * 0.025;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    SizedBox(height: topGap),

                    // =========================
                    // CAR IMAGE
                    // =========================
                    SizedBox(
                      width: double.infinity,
                      height: 170,
                      child: Image.asset(
                        'assets/cars/bmw_m4.png',
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Icon(
                            Icons.directions_car_filled_rounded,
                            size: 110,
                            color: Color(0xFF222222),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 5),

                    // =========================
                    // DRIVEHUB
                    // =========================
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'DriveHub',
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      widget.adminOnly ? 'Admin Login' : 'Premium Car Agency',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF666666),
                      ),
                    ),

                    const SizedBox(height: 38),

                    // =========================
                    // EMAIL
                    // =========================
                    LoginField(
                      label: 'Email Address',
                      hint: 'john.doe@example.com',
                      icon: Icons.mail,
                      controller: _email,
                      keyboardType:
                          TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 18),

                    // =========================
                    // PASSWORD
                    // =========================
                    LoginField(
                      label: 'Password',
                      hint: '••••••••',
                      hintColor: Colors.black,
                      icon: Icons.lock,
                      controller: _password,
                      obscure: true,
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // FORGOT PASSWORD
                    // =========================
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          pushScreen(
                            context,
                            const ForgotPasswordScreen(),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.linkBlue,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =========================
                    // LOGIN BUTTON
                    // =========================
                    PrimaryButton(
                      label: _loading
                          ? 'Please wait...'
                          : widget.adminOnly
                              ? 'Admin Login'
                              : 'User Login',
                      onPressed: _loading ? () {} : _login,
                      height: 54,
                      radius: 20,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      shadow: true,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // =========================
            // REGISTER
            // =========================
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Column(
                children: [
                  if (widget.adminOnly)
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back to user login'),
                    )
                  else ...[
                    GestureDetector(
                      onTap: () => pushScreen(
                        context,
                        const RegisterScreen(),
                      ),
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => pushScreen(
                        context,
                        const LoginScreen(adminOnly: true),
                      ),
                      child: const Text('Admin Login'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/primary_button.dart';
import '../admin/admin_shell.dart';
import '../user/user_shell.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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

  void _login() {
    FocusScope.of(context).unfocus();

    final isAdmin =
        _email.text.trim().toLowerCase().startsWith('admin');

    replaceAll(
      context,
      isAdmin ? const AdminShell() : const UserShell(),
    );
  }

  void _continueAsAdmin() {
    FocusScope.of(context).unfocus();

    replaceAll(
      context,
      const AdminShell(),
    );
  }

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

                    const Text(
                      'Premium Car Agency',
                      style: TextStyle(
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
                      label: 'Login',
                      onPressed: _login,
                      height: 54,
                      radius: 20,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      shadow: true,
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // ADMIN BUTTON
                    // =========================
                    PrimaryButton(
                      label: 'Continue as Admin',
                      onPressed: _continueAsAdmin,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      outlined: true,
                      height: 52,
                      radius: 18,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
              padding: const EdgeInsets.only(
                bottom: 28,
                top: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  pushScreen(
                    context,
                    const RegisterScreen(),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
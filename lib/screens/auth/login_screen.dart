import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/primary_button.dart';
import '../admin/admin_shell.dart';
import '../user/user_shell.dart';
import 'register_screen.dart';

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
    // Demo routing only: an email starting with "admin" opens the admin app.
    // Replace with real auth (e.g. FirebaseAuth) later.
    final isAdmin = _email.text.trim().toLowerCase().startsWith('admin');
    replaceAll(context, isAdmin ? const AdminShell() : const UserShell());
  }

  void _continueAsAdmin() {
    FocusScope.of(context).unfocus();
    replaceAll(context, const AdminShell());
  }

  @override
  Widget build(BuildContext context) {
    final topGap = MediaQuery.sizeOf(context).height * 0.07;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: topGap),
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
                    const Text('Premium Car Agency', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 52),
                    LoginField(
                      label: 'Email Address',
                      hint: 'john.doe@example.com',
                      icon: Icons.mail,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    LoginField(
                      label: 'Password',
                      hint: '••••••••',
                      hintColor: Colors.black,
                      icon: Icons.lock,
                      controller: _password,
                      obscure: true,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Forgot password screen not designed yet'),
                        )),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 28, top: 8),
              child: GestureDetector(
                onTap: () => pushScreen(context, const RegisterScreen()),
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [TextSpan(text: 'Register')],
                  ),
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

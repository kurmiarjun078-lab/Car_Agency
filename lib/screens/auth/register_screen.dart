import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../services/auth_service.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/primary_button.dart';
import '../user/user_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _loading = false;

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);

    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Name and email are required.')),
      );
      return;
    }
    if (_password.text != _confirm.text) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.instance.register(
        name: _name.text,
        phone: _phone.text,
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      replaceAll(context, const UserShell());
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(AuthService.friendlyError(e))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, size: 30),
                  ),
                  const Expanded(
                    child: Text(
                      'REGISTER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
                child: Column(
                  children: [
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sign up to get started',
                      style: TextStyle(fontSize: 19, color: Color(0xFF8E8E93)),
                    ),
                    const SizedBox(height: 26),
                    PillTextField(
                      label: 'Full Name',
                      hint: 'Enter your name',
                      controller: _name,
                    ),
                    const SizedBox(height: 12),
                    PillTextField(
                      label: 'Phone Number',
                      hint: 'Enter phone number',
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    PillTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    PillTextField(
                      label: 'Password',
                      hint: 'Enter password',
                      controller: _password,
                      isPassword: true,
                    ),
                    const SizedBox(height: 12),
                    PillTextField(
                      label: 'Confirm Password',
                      hint: 'Confirm password',
                      controller: _confirm,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: _loading ? 'Please wait...' : 'Register',
                      onPressed: _loading ? () {} : _register,
                      height: 48,
                      radius: 24,
                      fontSize: 18,
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Already have account? ',
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: AppColors.linkBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

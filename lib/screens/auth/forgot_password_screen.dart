import 'dart:async';

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  bool _isLoading = false;

  // DriveHub primary color
  static const Color primaryColor = Color(0xFFCB7600);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    // Demo loading
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          icon: Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 52,
            ),
          ),

          title: const Text(
            'Reset Link Sent',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            'A password reset link has been sent to\n'
            '${_emailController.text.trim()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black54,
            ),
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'BACK TO LOGIN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),

      // =========================
      // BODY
      // =========================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 25,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // =========================
                // LOCK ICON
                // =========================
                Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 58,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 28),

                // =========================
                // TITLE
                // =========================
                const Text(
                  'Forgot Your Password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),

                const SizedBox(height: 12),

                // =========================
                // DESCRIPTION
                // =========================
                Text(
                  'No worries! Enter your email address '
                  'and we will send you a link to reset '
                  'your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 35),

                // =========================
                // EMAIL LABEL
                // =========================
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // =========================
                // EMAIL FIELD
                // =========================
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: 'Enter your email',

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),

                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                  ),

                  // =========================
                  // VALIDATION
                  // =========================
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    final email = value.trim();

                    if (!email.contains('@') ||
                        !email.contains('.')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // =========================
                // SEND RESET BUTTON
                // =========================
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : _sendResetLink,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,

                      disabledBackgroundColor:
                          primaryColor.withAlpha(150),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),

                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'SEND RESET LINK',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // BACK TO LOGIN
                // =========================
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.arrow_back,
                    size: 18,
                  ),

                  label: const Text(
                    'Back to Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
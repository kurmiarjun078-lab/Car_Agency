import 'package:flutter/material.dart';

class DriveHubRegisterScreen extends StatefulWidget {
  const DriveHubRegisterScreen({super.key});

  @override
  State<DriveHubRegisterScreen> createState() => _DriveHubRegisterScreenState();
}

class _DriveHubRegisterScreenState extends State<DriveHubRegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA), // Light soft background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Back Button and Title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Title and Subtitle
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Input 1: Full Name
              _buildLabel('Full Name'),
              const SizedBox(height: 6),
              _buildInputField(
                hintText: 'Enter your name',
              ),
              const SizedBox(height: 16),

              // Input 2: Phone Number
              _buildLabel('Phone Number'),
              const SizedBox(height: 6),
              _buildInputField(
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Input 3: Email
              _buildLabel('Email'),
              const SizedBox(height: 6),
              _buildInputField(
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Input 4: Password
              _buildLabel('Password'),
              const SizedBox(height: 6),
              _buildInputField(
                hintText: 'Enter password',
                isPassword: true,
                obscureText: _obscurePassword,
                onEyeTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Input 5: Confirm Password
              _buildLabel('Confirm Password'),
              const SizedBox(height: 6),
              _buildInputField(
                hintText: 'Confirm password',
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                onEyeTap: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Register action logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Footer (Already have account? Login)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have account? ',
                    style: TextStyle(
                      color: Color(0xCC000000),
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Login Screen
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF2B78C2),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Form Field Label
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black54,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Helper Widget for Pill Rounded Input Field
  Widget _buildInputField({
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onEyeTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword ? obscureText : false,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xCC000000),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black38,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 16,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.black45,
                    size: 22,
                  ),
                  onPressed: onEyeTap,
                )
              : null,
        ),
      ),
    );
  }
}

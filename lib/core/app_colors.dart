import 'package:flutter/material.dart';

/// Colors sampled from the Figma screenshots.
class AppColors {
  AppColors._();

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color navy = Color(0xFF1C314C); // "Buy Now", details nav
  static const Color slateButton = Color(0xFF81848D); // "Book Test Drive"
  static const Color blue = Color(0xFF1370E7); // active tab on Browse Cars
  static const Color linkBlue = Color(0xFF2B6CB0); // Forgot password / Login link

  static const Color bgHome = Color(0xFFFAFAFA);
  static const Color bgOnboarding = Color(0xFFF6F7F9);
  static const Color bgProfile = Color(0xFFF4F5F7);
  static const Color bgAdmin = Color(0xFFECEBF0);
  static const Color bgDetailsImage = Color(0xFFF2F3F5);

  static const Color searchGrey = Color(0xFFE9EBEE);
  static const Color searchGreyDark = Color(0xFFCBCBCB);
  static const Color textGrey = Color(0xFF8A8A8E);
  static const Color textMuted = Color(0xFF5F6368);
  static const Color border = Color(0xFF858587);
  static const Color borderLight = Color(0xFFE2E3E7);
  static const Color divider = Color(0xFFE3E4E8);
  static const Color star = Color(0xFFFFB41F);
  static const Color serviceIconBg = Color(0xFFB4B7BE);
  static const Color iconTile = Color(0xFFF0F0F5);

  static const Color successBg = Color(0xFFD8F4E0);
  static const Color successText = Color(0xFF1E7B3C);
  static const Color successDot = Color(0xFF2EB859);
  static const Color pendingBg = Color(0xFFFFF0B8);
  static const Color pendingText = Color(0xFF7A5C00);
  static const Color pendingDot = Color(0xFFFFB800);
}

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 18, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 5)),
  ];
}

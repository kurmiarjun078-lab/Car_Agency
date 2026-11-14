import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.black,
    this.foregroundColor = Colors.white,
    this.outlined = false,
    this.height = 56,
    this.radius = 28,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w700,
    this.shadow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool outlined;
  final double height;
  final double radius;
  final double fontSize;
  final FontWeight fontWeight;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: outlined
          ? BorderSide(color: foregroundColor, width: 1.6)
          : BorderSide.none,
    );
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ? AppShadows.soft : null,
      ),
      child: Material(
        color: outlined ? Colors.transparent : backgroundColor,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

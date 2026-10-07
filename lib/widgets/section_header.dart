import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: AppColors.textGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

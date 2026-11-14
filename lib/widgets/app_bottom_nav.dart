import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class NavItemData {
  const NavItemData(this.icon, this.label, {this.activeIcon});
  final IconData icon;
  final IconData? activeIcon;
  final String label;
}

/// One bottom bar used by every screen; each Figma screen styles it a bit
/// differently, so the look is configurable.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.activeColor = AppColors.black,
    this.inactiveColor = AppColors.black,
    this.showLabels = true,
    this.showTopIndicator = false,
    this.boldActiveLabel = false,
    this.backgroundColor = Colors.white,
  });

  final List<NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;
  final Color inactiveColor;
  final bool showLabels;
  final bool showTopIndicator;
  final bool boldActiveLabel;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(top: BorderSide(color: Color(0xFFE6E6EA))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: showLabels ? 66 : 62,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(child: _item(i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(int i) {
    final selected = i == currentIndex;
    final color = selected ? activeColor : inactiveColor;
    final data = items[i];
    return InkWell(
      onTap: () => onTap(i),
      child: Stack(
        children: [
          if (showTopIndicator && selected)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(width: 36, height: 3, color: activeColor),
              ),
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? (data.activeIcon ?? data.icon) : data.icon,
                  size: 28,
                  color: color,
                ),
                if (showLabels) ...[
                  const SizedBox(height: 3),
                  Text(
                    data.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: color,
                      fontWeight: selected && boldActiveLabel
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

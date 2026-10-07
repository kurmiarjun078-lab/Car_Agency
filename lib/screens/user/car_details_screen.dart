import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../data/models.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/car_image.dart';
import '../../widgets/primary_button.dart';
import 'car_booking_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({super.key, required this.car});

  final Car car;

  static const _navItems = [
    NavItemData(Icons.home_outlined, '', activeIcon: Icons.home_filled),
    NavItemData(Icons.search, ''),
    NavItemData(Icons.calendar_today_outlined, ''),
    NavItemData(Icons.person_outline, ''),
  ];
  static const _tabFor = [0, 1, 2, 4];

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(onShare: () => _snack(context, 'Share (not wired yet)')),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ImageHero(
                      car: car,
                      onView360: () => _snack(context, '360° viewer (not wired yet)'),
                    ),
                    const SizedBox(height: 36),
                    Text(
                      car.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 14,
                      children: [
                        Text(
                          car.priceLabel,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              car.rating.toString(),
                              style: const TextStyle(fontSize: 17),
                            ),
                            const SizedBox(width: 3),
                            const Icon(Icons.star, size: 20, color: AppColors.star),
                            const SizedBox(width: 6),
                            Text(
                              '(${car.reviews} reviews)',
                              style: const TextStyle(
                                fontSize: 17,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 16),
                    _SpecsGrid(specs: car.specs),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 16),
                    _FeaturesGrid(features: car.features),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF0F0F2))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'Book Test Drive',
                      backgroundColor: AppColors.slateButton,
                      height: 54,
                      radius: 10,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      onPressed: () =>
                          pushScreen(context, CarBookingScreen(car: car)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Buy Now',
                      backgroundColor: AppColors.navy,
                      height: 54,
                      radius: 10,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      onPressed: () => _snack(context, 'Checkout (not designed yet)'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        items: _navItems,
        currentIndex: 0,
        showLabels: false,
        activeColor: AppColors.navy,
        inactiveColor: const Color(0xFF8E8E93),
        onTap: (i) => goToUserTab(context, _tabFor[i]),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onShare});
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE3E3E6))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.chevron_left, size: 36),
          ),
          const Expanded(
            child: Text(
              'DriveHub',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share, size: 26),
          ),
        ],
      ),
    );
  }
}

class _ImageHero extends StatelessWidget {
  const _ImageHero({required this.car, required this.onView360});
  final Car car;
  final VoidCallback onView360;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 1.72,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgDetailsImage,
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: CarImage(asset: car.imageAsset, fit: BoxFit.contain),
          ),
        ),
        Positioned(
          bottom: -22,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.white,
              elevation: 4,
              shadowColor: Colors.black26,
              shape: const StadiumBorder(),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: onView360,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.threesixty, size: 24),
                      SizedBox(width: 8),
                      Text(
                        '360 View',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  const _SpecsGrid({required this.specs});
  final List<CarSpec> specs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final itemWidth = (c.maxWidth - 20) / 3;
      return Wrap(
        spacing: 10,
        runSpacing: 18,
        children: [
          for (final s in specs)
            SizedBox(
              width: itemWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(s.icon, size: 26, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          s.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class _FeaturesGrid extends StatelessWidget {
  const _FeaturesGrid({required this.features});
  final List<CarFeature> features;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final itemWidth = (c.maxWidth - 12) / 2;
      return Wrap(
        spacing: 12,
        runSpacing: 16,
        children: [
          for (final f in features)
            SizedBox(
              width: itemWidth,
              child: Row(
                children: [
                  Icon(f.icon, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      f.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

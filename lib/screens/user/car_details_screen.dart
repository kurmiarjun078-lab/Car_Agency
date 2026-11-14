import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../data/models.dart';
import '../../services/db_service.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/car_image.dart';
import '../../widgets/heart_button.dart';
import '../../widgets/primary_button.dart';
import 'car_booking_screen.dart';
import 'gallery_screen.dart';

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

  /// Copies the car summary so it can be pasted into WhatsApp, SMS, etc.
  Future<void> _share(BuildContext context) async {
    final text = '${car.name} (${car.brand})\n'
        'Price: ${car.priceLabel}\n'
        '${car.fuel} | ${car.transmission} | ${car.seats} seats\n'
        'Book a test drive on DriveHub!';
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Car details copied. You can paste them anywhere.')),
    );
  }

  void _openGallery(BuildContext context) {
    pushScreen(context, GalleryScreen(title: car.name, images: car.allImages));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(car: car, onShare: () => _share(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ImageHero(
                      car: car,
                      onOpenGallery: () => _openGallery(context),
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
                        _CarRating(car: car),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 16),
                    _SpecsGrid(specs: car.specs),
                    if (car.featureItems.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 16),
                      _FeaturesGrid(features: car.featureItems),
                    ],
                    if (car.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 16),
                      const Text(
                        'About this car',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        car.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
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

class _CarRating extends StatefulWidget {
  const _CarRating({required this.car});

  final Car car;

  @override
  State<_CarRating> createState() => _CarRatingState();
}

class _CarRatingState extends State<_CarRating> {
  late final Stream<CarRatingSummary> _ratings =
      DbService.instance.watchCarRatings(widget.car);
  bool _saving = false;

  Future<void> _rate(int value) async {
    setState(() => _saving = true);
    try {
      await DbService.instance.rateCar(widget.car.id, value);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating saved')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save rating: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CarRatingSummary>(
      stream: _ratings,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Could not load ratings: ${snapshot.error}');
        }

        final summary = snapshot.data;
        final count = summary?.count ?? widget.car.reviews;
        final average = summary?.average ?? widget.car.rating;
        final userRating = summary?.userRating ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  count == 0 ? 'No ratings yet' : average.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 17),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 3),
                  const Icon(Icons.star, size: 20, color: AppColors.star),
                  const SizedBox(width: 6),
                  Text(
                    '($count ${count == 1 ? 'review' : 'reviews'})',
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              userRating == 0
                  ? 'Tap a star to rate this car'
                  : 'Your rating: $userRating stars · tap to change',
              style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var value = 1; value <= 5; value++)
                  IconButton(
                    onPressed:
                        summary == null || _saving ? null : () => _rate(value),
                    tooltip: 'Rate $value stars',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      value <= userRating ? Icons.star : Icons.star_border,
                      color: AppColors.star,
                    ),
                  ),
                if (_saving)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.car, required this.onShare});
  final Car car;
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
          HeartButton(car: car, size: 30, color: Colors.black),
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share, size: 26),
          ),
        ],
      ),
    );
  }
}

class _ImageHero extends StatefulWidget {
  const _ImageHero({required this.car, required this.onOpenGallery});
  final Car car;
  final VoidCallback onOpenGallery;

  @override
  State<_ImageHero> createState() => _ImageHeroState();
}

class _ImageHeroState extends State<_ImageHero> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.car.allImages;
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
            child: images.length <= 1
                ? CarImage(
                    asset: images.isEmpty ? null : images.first,
                    fit: BoxFit.contain,
                  )
                : Stack(
                    children: [
                      PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemBuilder: (_, i) =>
                            CarImage(asset: images[i], fit: BoxFit.contain),
                      ),
                      Positioned(
                        top: 10,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_page + 1}/${images.length}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                onTap: widget.onOpenGallery,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_library_outlined, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
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

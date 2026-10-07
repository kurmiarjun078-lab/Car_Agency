import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../data/models.dart';
import '../../data/wishlist_store.dart';
import '../../widgets/car_image.dart';
import '../../widgets/primary_button.dart';
import 'car_booking_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, this.onBack});

  /// When shown as a tab, back returns to Home. When pushed, it pops.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 14, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, size: 32),
                  ),
                  const Expanded(
                    child: Text(
                      'My Wishlist',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.favorite_border, size: 32),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Car>>(
                valueListenable: WishlistStore.items,
                builder: (context, cars, _) {
                  if (cars.isEmpty) {
                    return const Center(
                      child: Text(
                        'Your wishlist is empty',
                        style: TextStyle(fontSize: 18, color: AppColors.textGrey),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    itemCount: cars.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (_, i) => _WishlistCard(car: cars[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  const _WishlistCard({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 11,
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: CarImage(asset: car.imageAsset, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        car.priceLabel,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Book Now',
                  height: 48,
                  radius: 12,
                  fontSize: 18,
                  onPressed: () =>
                      pushScreen(context, CarBookingScreen(car: car)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

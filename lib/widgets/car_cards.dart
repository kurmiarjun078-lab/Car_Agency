import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/models.dart';
import 'car_image.dart';
import 'heart_button.dart';

/// Card used in the "Browse Cars" grid. Total height = width * imageRatio + infoHeight.
class BrowseCarCard extends StatelessWidget {
  const BrowseCarCard({super.key, required this.car, this.onTap});

  static const double imageRatio = 0.76;
  static const double infoHeight = 70;

  final Car car;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1 / imageRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CarImage(asset: car.imageAsset),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: HeartButton(car: car, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: infoHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              car.priceLabel,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.star, size: 18, color: AppColors.star),
                        const SizedBox(width: 3),
                        Text(
                          car.rating.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
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

/// Card used on the "Car Listings" screen (Poppins, fuel + gearbox row).
class ListingCarCard extends StatelessWidget {
  const ListingCarCard({super.key, required this.car, this.onTap});

  static const double imageRatio = 0.56;
  static const double infoHeight = 112;

  final Car car;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1 / imageRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CarImage(asset: car.imageAsset),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: HeartButton(car: car, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: infoHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      car.priceLabel,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: _Spec(icon: Icons.local_gas_station, text: car.fuel),
                        ),
                        Expanded(
                          child: _Spec(icon: Icons.settings, text: car.transmission),
                        ),
                      ],
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

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.black),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: AppFonts.poppins, fontSize: 12.5),
          ),
        ),
      ],
    );
  }
}

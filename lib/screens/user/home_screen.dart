import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/navigation.dart';
import '../../data/app_data.dart';
import '../../data/car_filter.dart';
import '../../data/car_store.dart';
import '../../data/models.dart';
import '../../data/profile_store.dart';
import '../../services/auth_service.dart';
import '../../widgets/car_image.dart';
import '../../widgets/heart_button.dart';
import '../../widgets/section_header.dart';
import 'car_details_screen.dart';
import 'car_listings_screen.dart';
// import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate});

  /// Switches the bottom-nav tab (used by the "See All" links).
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    const pad = 22.0;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: pad),
            child: _Header(onProfileTap: () => onNavigate(4)),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: pad),
            child: _SearchBox(
              onSubmit: (q) => pushScreen(
                context,
                CarListingsScreen(initialQuery: q.trim()),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _Categories(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: pad),
            child: SectionHeader(
              title: 'Featured Cars',
              onSeeAll: () => pushScreen(context, const CarListingsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _FeaturedList(width: width),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: pad),
            child: SectionHeader(
              title: 'Popular Brands',
              onSeeAll: () => pushScreen(context, const CarListingsScreen()),
            ),
          ),
          const SizedBox(height: 12),
          const _BrandsList(),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: pad),
            child: SectionHeader(
              title: 'Recommended For You',
              onSeeAll: () => onNavigate(1),
            ),
          ),
          const SizedBox(height: 12),
          _RecommendedList(width: width),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onProfileTap});

  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: ProfileStore.user,
      builder: (context, profile, _) {
        var name = profile?.name ?? '';
        if (name.isEmpty) {
          name = AuthService.instance.currentUser?.displayName ?? '';
        }
        final first =
            name.trim().isEmpty ? 'there' : name.trim().split(' ').first;
        return Row(
          children: [
            Tooltip(
              message: 'Profile',
              child: InkWell(
                onTap: onProfileTap,
                customBorder: const CircleBorder(),
                child: Avatar(size: 52, name: name, photo: profile?.photo),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $first',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Find your dream car',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14.5,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            // IconButton(
            //   onPressed: () => pushScreen(context, const NotificationsScreen()),
            //   icon: const Icon(Icons.notifications, size: 30),
            // ),
          ],
        );
      },
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.onSubmit});
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 26, color: AppColors.textGrey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onSubmitted: onSubmit,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 17),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search cars...',
                hintStyle: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 16,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: AppData.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, i) {
          final c = AppData.categories[i];
          return GestureDetector(
              onTap: () => pushScreen(
                    context,
                    CarListingsScreen(
                        initialFilter: CarFilter(category: c.label)),
                  ),
              child: SizedBox(
                width: 58,
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.card,
                      ),
                      child: Icon(c.icon, size: 28),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      c.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      child: ValueListenableBuilder<bool>(
        valueListenable: CarStore.loading,
        builder: (context, loading, _) => Center(
          child: loading
              ? const CircularProgressIndicator()
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textGrey),
                ),
        ),
      ),
    );
  }
}

class _FeaturedList extends StatelessWidget {
  const _FeaturedList({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width - 22 - 28; // leaves a peek of the next card
    final cardHeight = cardWidth * 0.48;
    return ValueListenableBuilder<List<Car>>(
      valueListenable: CarStore.items,
      builder: (context, _, __) {
        final cars = CarStore.featured;
        if (cars.isEmpty) {
          return const _EmptyHint('No cars are available yet.');
        }
        return SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: cars.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => SizedBox(
              width: cardWidth,
              child: _FeaturedCard(car: cars[i]),
            ),
          ),
        );
      },
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.car});
  final Car car;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pushScreen(context, CarDetailsScreen(car: car)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.soft,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3A3A3E), Color(0xFF0E0E10)],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 44),
              child:
                  CarImage(asset: car.image, dark: true, fit: BoxFit.contain),
            ),
            // Bottom gradient so the white text stays readable.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xB3000000)],
                  stops: [0.45, 1],
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      car.rating.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 56,
              bottom: 14,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    car.priceLabel,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 8,
              child: HeartButton(car: car, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandsList extends StatelessWidget {
  const _BrandsList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: AppData.popularBrands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final name = AppData.popularBrands.keys.elementAt(i);
          final logo = AppData.popularBrands[name]!;
          return GestureDetector(
              onTap: () => pushScreen(
                    context,
                    CarListingsScreen(initialFilter: CarFilter(brand: name)),
                  ),
              child: Container(
                width: 62,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: Image.asset(
                        logo,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(name[0],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Center(
                        child: Text(
                          name,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, height: 1.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class _RecommendedList extends StatelessWidget {
  const _RecommendedList({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width * 0.5;
    final imageHeight = cardWidth * 0.62;
    return ValueListenableBuilder<List<Car>>(
      valueListenable: CarStore.items,
      builder: (context, all, _) {
        if (all.isEmpty) return const SizedBox.shrink();
        final cars = [...all]..sort((a, b) => b.rating.compareTo(a.rating));
        final shown = cars.take(8).toList();
        return SizedBox(
          height: imageHeight + 62,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: shown.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (_, i) {
              final car = shown[i];
              return SizedBox(
                width: cardWidth,
                child: GestureDetector(
                  onTap: () => pushScreen(context, CarDetailsScreen(car: car)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: imageHeight,
                        child: CarImage(asset: car.image, radius: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        car.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        car.priceLabel,
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

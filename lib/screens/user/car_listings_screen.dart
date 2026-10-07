import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/navigation.dart';
import '../../data/car_filter.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/car_cards.dart';
import 'car_details_screen.dart';
import 'car_filter_sheet.dart';

/// "Car Listings" design (Poppins, USD prices, Home/Listings/Favorites/Profile bar).
class CarListingsScreen extends StatefulWidget {
  const CarListingsScreen({super.key});

  @override
  State<CarListingsScreen> createState() => _CarListingsScreenState();
}

class _CarListingsScreenState extends State<CarListingsScreen> {
  String _query = '';
  CarFilter _filter = CarFilter.empty;

  static const _items = [
    NavItemData(Icons.home_outlined, 'Home', activeIcon: Icons.home),
    NavItemData(Icons.manage_search, 'Listings'),
    NavItemData(Icons.favorite_border, 'Favorites', activeIcon: Icons.favorite),
    NavItemData(Icons.person_outline, 'Profile', activeIcon: Icons.person),
  ];

  // Nav index -> UserShell tab index.
  static const _tabFor = [0, 1, 3, 4];

  Future<void> _openFilter() async {
    final r = await showCarFilterSheet(context, _filter);
    if (r != null) setState(() => _filter = r);
  }

  @override
  Widget build(BuildContext context) {
    final cars = MockData.listingCars
        .where((c) =>
            '${c.name} ${c.brand}'.toLowerCase().contains(_query.toLowerCase()) &&
            _filter.matches(c, usePrice: false)) // prices here are in USD
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          const hPad = 14.0;
          const gap = 14.0;
          final cardWidth = (constraints.maxWidth - hPad * 2 - gap) / 2;
          final cardHeight =
              cardWidth * ListingCarCard.imageRatio + ListingCarCard.infoHeight;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Car Listings',
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => goToUserTab(context, 4),
                            icon: const Icon(Icons.account_circle_outlined, size: 34),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: AppColors.searchGrey,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search,
                                      color: AppColors.textGrey, size: 26),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (v) => setState(() => _query = v),
                                      style: const TextStyle(
                                        fontFamily: AppFonts.poppins,
                                        fontSize: 15,
                                      ),
                                      decoration: const InputDecoration(
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        hintText: 'Search cars, models, or brands...',
                                        hintStyle: TextStyle(
                                          fontFamily: AppFonts.poppins,
                                          fontSize: 15,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _openFilter,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.searchGrey,
                                borderRadius: BorderRadius.circular(14),
                                border: _filter.isEmpty
                                    ? null
                                    : Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: const Icon(Icons.tune, size: 26),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (cars.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No cars found')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(hPad, 0, hPad, 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: gap,
                      mainAxisExtent: cardHeight,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => ListingCarCard(
                        car: cars[i],
                        onTap: () =>
                            pushScreen(context, CarDetailsScreen(car: cars[i])),
                      ),
                      childCount: cars.length,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
      bottomNavigationBar: AppBottomNav(
        items: _items,
        currentIndex: 1,
        onTap: (i) {
          if (i != 1) goToUserTab(context, _tabFor[i]);
        },
        activeColor: Colors.black,
        inactiveColor: const Color(0xFF8E8E93),
        boldActiveLabel: true,
      ),
    );
  }
}

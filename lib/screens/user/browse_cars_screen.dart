import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/navigation.dart';
import '../../data/car_filter.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/car_cards.dart';
import '../../widgets/form_fields.dart';
import 'car_details_screen.dart';
import 'car_filter_sheet.dart';

class BrowseCarsScreen extends StatefulWidget {
  const BrowseCarsScreen({super.key});

  @override
  State<BrowseCarsScreen> createState() => _BrowseCarsScreenState();
}

class _BrowseCarsScreenState extends State<BrowseCarsScreen> {
  String _query = '';
  CarFilter _filter = CarFilter.empty;
  SortOption _sort = SortOption.none;
  Key _searchFieldKey = UniqueKey();

  List<Car> get _cars {
    final query = _query.trim().toLowerCase();
    final list = MockData.browseCars
        .where((c) =>
            '${c.name} ${c.brand}'.toLowerCase().contains(query) &&
            _filter.matches(c))
        .toList();
    switch (_sort) {
      case SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.none:
        break;
    }
    return list;
  }

  Future<void> _openFilter() async {
    final result = await showCarFilterSheet(context, _filter);
    if (result != null) setState(() => _filter = result);
  }

  Future<void> _openSort() async {
    final result = await showModalBottomSheet<SortOption>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            for (final entry in const {
              SortOption.none: 'Default',
              SortOption.priceLow: 'Price: Low to High',
              SortOption.priceHigh: 'Price: High to Low',
              SortOption.rating: 'Top Rated',
            }.entries)
              ListTile(
                title: Text(entry.value),
                trailing: _sort == entry.key
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
                onTap: () => Navigator.of(context).pop(entry.key),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (result != null) setState(() => _sort = result);
  }

  void _resetBrowse() {
    setState(() {
      _query = '';
      _filter = CarFilter.empty;
      _sort = SortOption.none;
      _searchFieldKey = UniqueKey();
    });
  }

  Future<void> _refresh() async {
    _resetBrowse();
  }

  @override
  Widget build(BuildContext context) {
    final cars = _cars;
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(builder: (context, constraints) {
        const hPad = 14.0;
        const gap = 14.0;
        final cardWidth = (constraints.maxWidth - hPad * 2 - gap) / 2;
        final cardHeight =
            cardWidth * BrowseCarCard.imageRatio + BrowseCarCard.infoHeight;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(hPad, 28, hPad, 0),
                  child: Column(
                    children: [
                      const Text(
                        'Browse Cars',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 18),
                      SearchPill(
                        key: _searchFieldKey,
                        hint: 'Search cars...',
                        color: AppColors.searchGreyDark,
                        height: 50,
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.tune,
                              label: 'Filter',
                              highlighted: !_filter.isEmpty,
                              onTap: _openFilter,
                            ),
                          ),
                          const SizedBox(width: gap),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.sort,
                              label: 'Sort',
                              highlighted: _sort != SortOption.none,
                              onTap: _openSort,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
              if (cars.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.directions_car_outlined,
                            size: 48,
                            color: AppColors.textGrey,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No cars match your search or filters',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: _resetBrowse,
                            icon: const Icon(Icons.filter_alt_off_outlined),
                            label: const Text('Clear search and filters'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      (context, i) => BrowseCarCard(
                        car: cars[i],
                        onTap: () =>
                            pushScreen(context, CarDetailsScreen(car: cars[i])),
                      ),
                      childCount: cars.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlighted ? Colors.black : AppColors.borderLight,
            width: highlighted ? 1.6 : 1,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 19)),
          ],
        ),
      ),
    );
  }
}

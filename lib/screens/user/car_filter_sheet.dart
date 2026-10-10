import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../data/car_filter.dart';
import '../../data/mock_data.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/primary_button.dart';

/// "Filter" bottom sheet. Returns the chosen [CarFilter] (or null if dismissed).
Future<CarFilter?> showCarFilterSheet(BuildContext context, CarFilter current) {
  return showModalBottomSheet<CarFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CarFilterSheet(initial: current),
  );
}

class CarFilterSheet extends StatefulWidget {
  const CarFilterSheet({super.key, required this.initial});
  final CarFilter initial;

  @override
  State<CarFilterSheet> createState() => _CarFilterSheetState();
}

class _CarFilterSheetState extends State<CarFilterSheet> {
  static const double _min = 500000; // slider domain
  static const double _max = 8000000;
  static const RangeValues _defaultRange = RangeValues(1000000, 5000000);

  late RangeValues _range;
  String? _brand;
  String? _fuel;
  String? _transmission;
  String? _seats;
  int? _color;

  @override
  void initState() {
    super.initState();
    final f = widget.initial;
    _range = RangeValues(
      (f.minPrice ?? _defaultRange.start.toInt()).toDouble(),
      (f.maxPrice ?? _defaultRange.end.toInt()).toDouble(),
    );
    _brand = f.brand;
    _fuel = f.fuel;
    _transmission = f.transmission;
    _seats = f.seats;
    _color = f.colorIndex;
  }

  void _reset() => setState(() {
        _range = _defaultRange;
        _brand = _fuel = _transmission = _seats = null;
        _color = null;
      });

  void _apply() {
    final priceTouched = _range != _defaultRange;
    Navigator.of(context).pop(CarFilter(
      minPrice: priceTouched ? _range.start.round() : null,
      maxPrice: priceTouched ? _range.end.round() : null,
      brand: _brand,
      fuel: _fuel,
      transmission: _transmission,
      seats: _seats,
      colorIndex: _color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.94;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1D26),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Price Range',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5,
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: const Color(0xFFDDE0E8),
                    overlayColor: Colors.black12,
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 10,
                      elevation: 2,
                    ),
                    thumbColor: Colors.white,
                  ),
                  child: RangeSlider(
                    values: _range,
                    min: _min,
                    max: _max,
                    onChanged: (v) => setState(() => _range = v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatPrice(_range.start.round()),
                          style: const TextStyle(fontSize: 16)),
                      Text(formatPrice(_range.end.round()),
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DropdownCard(
                  label: 'Brand',
                  hint: 'Select Brand',
                  items: MockData.brands,
                  value: _brand,
                  onChanged: (v) => setState(() => _brand = v),
                ),
                const SizedBox(height: 12),
                DropdownCard(
                  label: 'Fuel Type',
                  hint: 'Select Fuel Type',
                  items: MockData.fuelTypes,
                  value: _fuel,
                  onChanged: (v) => setState(() => _fuel = v),
                ),
                const SizedBox(height: 12),
                DropdownCard(
                  label: 'Transmission',
                  hint: 'Select Transmission',
                  items: MockData.transmissions,
                  value: _transmission,
                  onChanged: (v) => setState(() => _transmission = v),
                ),
                const SizedBox(height: 12),
                DropdownCard(
                  label: 'Seats',
                  hint: 'Select Seats',
                  items: MockData.seatOptions,
                  value: _seats,
                  onChanged: (v) => setState(() => _seats = v),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Color',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < MockData.filterColors.length; i++)
                      _ColorDot(
                        color: MockData.filterColors[i],
                        selected: _color == i,
                        onTap: () =>
                            setState(() => _color = _color == i ? null : i),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Reset',
                        onPressed: _reset,
                        outlined: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        height: 52,
                        radius: 26,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Apply Filter',
                        onPressed: _apply,
                        height: 52,
                        radius: 26,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.black : AppColors.borderLight,
            width: selected ? 2 : 1.2,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: color == Colors.white
                ? Border.all(color: AppColors.borderLight)
                : null,
          ),
        ),
      ),
    );
  }
}

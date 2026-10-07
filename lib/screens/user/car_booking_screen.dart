import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/car_image.dart';
import '../../widgets/primary_button.dart';

class CarBookingScreen extends StatefulWidget {
  const CarBookingScreen({super.key, required this.car});

  final Car car;

  @override
  State<CarBookingScreen> createState() => _CarBookingScreenState();
}

class _CarBookingScreenState extends State<CarBookingScreen> {
  String _time = '10:00 AM';

  // Static in the Figma; hook these up to real dealer data later.
  static const _dealer = 'DriveHub Motors';
  static const _location = 'Kathmandu, Nepal';

  Future<void> _confirm() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Booking confirmed'),
        content: Text(
          '${widget.car.name} at $_dealer, $_location\nTime: $_time',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 0, 0),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, size: 32),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 8, 26, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(car.priceLabel, style: const TextStyle(fontSize: 26)),
                    const SizedBox(height: 18),
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: CarImage(asset: car.imageAsset, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 22),
                    const _InfoCard(
                      icon: Icons.directions_car_filled,
                      label: 'Dealer',
                      value: _dealer,
                    ),
                    const SizedBox(height: 14),
                    const _InfoCard(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: _location,
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(
                      icon: Icons.access_time_filled,
                      label: 'Select Time',
                      valueWidget: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: _time,
                          icon: const Icon(Icons.arrow_drop_down, size: 30),
                          style: const TextStyle(
                            fontSize: 21,
                            color: Colors.black,
                          ),
                          items: [
                            for (final t in MockData.dealerTimes)
                              DropdownMenuItem(value: t, child: Text(t)),
                          ],
                          onChanged: (v) => setState(() => _time = v ?? _time),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    PrimaryButton(
                      label: 'Confirm Booking',
                      onPressed: _confirm,
                      height: 58,
                      radius: 22,
                      fontSize: 21,
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 36 + 8,
            height: 36 + 8,
            decoration: BoxDecoration(
              color: AppColors.iconTile,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                valueWidget ??
                    Text(
                      value ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 21),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

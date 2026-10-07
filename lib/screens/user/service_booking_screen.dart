import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../data/mock_data.dart';
import '../../widgets/primary_button.dart';

class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  int _selected = 0;
  // Initial values copied from the Figma. Use DateTime.now() in production.
  DateTime _date = DateTime(2024, 5, 24);
  TimeOfDay _time = const TimeOfDay(hour: 11, minute: 0);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _confirm() {
    final s = MockData.services[_selected];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '${s.name} booked for ${formatDate(_date)}, ${_time.format(context)}',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Service Booking',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Select Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < MockData.services.length; i++) ...[
              _ServiceTile(
                icon: MockData.services[i].icon,
                name: MockData.services[i].name,
                price: formatPrice(MockData.services[i].price),
                selected: i == _selected,
                onTap: () => setState(() => _selected = i),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 6),
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            _PickerField(
              text: formatDate(_date),
              icon: Icons.calendar_month,
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            _PickerField(
              text: _time.format(context),
              icon: Icons.access_time,
              onTap: _pickTime,
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Confirm Service',
              onPressed: _confirm,
              height: 54,
              radius: 27,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.name,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String name;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.black : const Color(0xFF3A3A3C),
            width: selected ? 2.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.serviceIconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 19),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                price,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(child: Text(text, style: const TextStyle(fontSize: 19))),
            Icon(icon, size: 26),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../widgets/car_image.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  String _query = '';
  String _filter = 'All';

  static const _bookings = [
    _Booking(
      id: 'BK-1024',
      customer: 'Bishal Thapa',
      car: 'BMW M4 Coupe',
      date: 'Oct 12, 2026',
      price: 7500000,
      status: 'Confirmed',
      image: 'assets/cars/bmw_m4.png',
    ),
    _Booking(
      id: 'BK-1023',
      customer: 'Sagar Acharya',
      car: 'Audi A6',
      date: 'Oct 14, 2026',
      price: 6500000,
      status: 'Pending',
      image: 'assets/cars/audi_a6.png',
    ),
    _Booking(
      id: 'BK-1022',
      customer: 'Alex Shrestha',
      car: 'Tesla Model Y',
      date: 'Oct 08, 2026',
      price: 5500000,
      status: 'Completed',
      image: 'assets/cars/tesla_model_y.png',
    ),
    _Booking(
      id: 'BK-1021',
      customer: 'Rohan Karki',
      car: 'Mercedes C-Class',
      date: 'Oct 18, 2026',
      price: 6600000,
      status: 'Pending',
      image: 'assets/cars/mercedes_c_class.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final bookings = _bookings.where((booking) {
      final matchesQuery = booking.id.toLowerCase().contains(query) ||
          booking.customer.toLowerCase().contains(query) ||
          booking.car.toLowerCase().contains(query);
      final matchesFilter = _filter == 'All' || booking.status == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return Container(
      color: AppColors.bgAdmin,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MANAGE BOOKINGS',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Review and track customer reservations',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: const [
                      Expanded(
                        child: _BookingMetric(
                          label: 'Total',
                          value: '24',
                          icon: Icons.calendar_month_rounded,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _BookingMetric(
                          label: 'Pending',
                          value: '06',
                          icon: Icons.pending_actions_rounded,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _BookingMetric(
                          label: 'Completed',
                          value: '18',
                          icon: Icons.task_alt_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search customer, car or booking ID',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final filter in const [
                          'All',
                          'Pending',
                          'Confirmed',
                          'Completed',
                        ])
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: _filter == filter,
                              onSelected: (_) => setState(() => _filter = filter),
                              selectedColor: AppColors.black,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _filter == filter
                                    ? Colors.white
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                              side: BorderSide.none,
                              showCheckmark: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: bookings.isEmpty
                  ? const Center(
                      child: Text(
                        'No bookings found',
                        style: TextStyle(
                            fontSize: 16, color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
                      itemCount: bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _BookingCard(
                        booking: bookings[index],
                        onTap: () => _showDetails(context, bookings[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, _Booking booking) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Booking details',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                  _BookingStatus(status: booking.status),
                ],
              ),
              const SizedBox(height: 18),
              _DetailLine(label: 'Booking ID', value: booking.id),
              _DetailLine(label: 'Customer', value: booking.customer),
              _DetailLine(label: 'Vehicle', value: booking.car),
              _DetailLine(label: 'Booking date', value: booking.date),
              _DetailLine(
                label: 'Vehicle price',
                value: formatPrice(booking.price),
                isLast: true,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Booking {
  const _Booking({
    required this.id,
    required this.customer,
    required this.car,
    required this.date,
    required this.price,
    required this.status,
    required this.image,
  });

  final String id;
  final String customer;
  final String car;
  final String date;
  final int price;
  final String status;
  final String image;
}

class _BookingMetric extends StatelessWidget {
  const _BookingMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: AppColors.textMuted),
          const SizedBox(height: 9),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.onTap});

  final _Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.id,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  _BookingStatus(status: booking.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 92,
                    height: 72,
                    child: CarImage(asset: booking.image, radius: 12),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.car,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          booking.customer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.event_outlined,
                                size: 15, color: AppColors.textGrey),
                            const SizedBox(width: 4),
                            Text(
                              booking.date,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Vehicle price',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  Text(
                    formatPrice(booking.price),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textGrey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingStatus extends StatelessWidget {
  const _BookingStatus({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      'Confirmed' => (AppColors.successBg, AppColors.successText),
      'Completed' => (const Color(0xFFE8EFFA), const Color(0xFF315A91)),
      _ => (AppColors.pendingBg, AppColors.pendingText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(color: AppColors.textMuted)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

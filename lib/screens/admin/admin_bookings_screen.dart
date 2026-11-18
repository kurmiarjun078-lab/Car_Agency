import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../data/car_store.dart';
import '../../data/models.dart';
import '../../services/db_service.dart';
import '../../widgets/car_image.dart';
import '../../widgets/status_chip.dart';

/// Admin: all test-drive and service bookings (live), with status updates.
class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  late final Stream<List<BookingItem>> _stream =
      DbService.instance.watchBookings();
  String _query = '';
  String _filter = 'All';

  Future<void> _openDetails(BookingItem b) async {
    final status = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSheet(booking: b),
    );
    if (status == null || status == b.status) return;
    try {
      await DbService.instance.setBookingStatus(b, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${b.code} is now $status.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgAdmin,
      child: SafeArea(
        bottom: false,
        child: StreamBuilder<List<BookingItem>>(
          stream: _stream,
          builder: (context, snap) {
            final all = snap.data ?? const <BookingItem>[];
            final query = _query.trim().toLowerCase();
            final list = all.where((b) {
              final matchesQuery = query.isEmpty ||
                  b.code.toLowerCase().contains(query) ||
                  b.customer.toLowerCase().contains(query) ||
                  b.title.toLowerCase().contains(query);
              return matchesQuery && (_filter == 'All' || b.status == _filter);
            }).toList();
            int count(String s) => all.where((b) => b.status == s).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MANAGE BOOKINGS',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Test drives and service reservations',
                        style:
                            TextStyle(fontSize: 14, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _Metric(
                              label: 'Total',
                              value: '${all.length}',
                              icon: Icons.calendar_month_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Metric(
                              label: 'Pending',
                              value: '${count('Pending')}',
                              icon: Icons.pending_actions_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Metric(
                              label: 'Completed',
                              value: '${count('Completed')}',
                              icon: Icons.task_alt_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'Search customer, car or booking ID',
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final f in ['All', ...BookingItem.statuses])
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(f),
                                  selected: _filter == f,
                                  onSelected: (_) =>
                                      setState(() => _filter = f),
                                  selectedColor: Colors.black,
                                  labelStyle: TextStyle(
                                    color: _filter == f
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  backgroundColor: Colors.white,
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
                  child: snap.hasError
                      ? Center(
                          child: Text('Could not load bookings: ${snap.error}'))
                      : !snap.hasData
                          ? const Center(child: CircularProgressIndicator())
                          : list.isEmpty
                              ? const Center(child: Text('No bookings found.'))
                              : ListView.separated(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 4, 18, 18),
                                  itemCount: list.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (_, i) => _BookingCard(
                                    booking: list[i],
                                    onTap: () => _openDetails(list[i]),
                                  ),
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(label,
              style:
                  const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.onTap});
  final BookingItem booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final image = CarStore.byId(b.carId)?.image ?? b.image;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 54,
              child: b.type == BookingType.testDrive
                  ? CarImage(asset: image, radius: 10)
                  : Container(
                      decoration: BoxDecoration(
                        color: AppColors.serviceIconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.build_outlined),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    b.customer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '${b.code} - ${formatDate(b.date)}, ${b.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusChip(b.status),
          ],
        ),
      ),
    );
  }
}

class _BookingSheet extends StatelessWidget {
  const _BookingSheet({required this.booking});
  final BookingItem booking;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    Widget row(String l, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                child:
                    Text(l, style: const TextStyle(color: AppColors.textMuted)),
              ),
              Expanded(
                child: Text(v,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${b.code} - ${b.typeLabel}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  StatusChip(b.status),
                ],
              ),
              const SizedBox(height: 10),
              row(b.type == BookingType.testDrive ? 'Car' : 'Service', b.title),
              row('Customer', b.customer),
              if (b.phone.isNotEmpty) row('Phone', b.phone),
              row('Date', formatDate(b.date)),
              row('Time', b.time),
              if (b.location.isNotEmpty) row('Location', b.location),
              row('Amount', formatPrice(b.price)),
              const SizedBox(height: 14),
              const Text('Change status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in BookingItem.statuses)
                    ChoiceChip(
                      label: Text(s),
                      selected: b.status == s,
                      showCheckmark: false,
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                        color: b.status == s ? Colors.white : Colors.black,
                      ),
                      onSelected: (_) => Navigator.of(context).pop(s),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

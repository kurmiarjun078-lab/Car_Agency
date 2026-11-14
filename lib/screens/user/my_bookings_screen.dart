import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../core/navigation.dart';
import '../../data/car_store.dart';
import '../../data/models.dart';
import '../../services/auth_service.dart';
import '../../services/db_service.dart';
import '../../widgets/car_image.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_chip.dart';
import 'service_booking_screen.dart';

/// The user's test-drive and service bookings (live from Firestore).
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key, this.showBack = false});

  /// true when opened from Profile (shows a back arrow).
  final bool showBack;

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late final Stream<List<BookingItem>> _stream = DbService.instance
      .watchBookings(userId: AuthService.instance.currentUser?.uid ?? '-');
  BookingType _tab = BookingType.testDrive;

  Future<void> _cancel(BookingItem b) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text('${b.title} - ${formatDate(b.date)}, ${b.time}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await DbService.instance.setBookingStatus(b, 'Cancelled');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not cancel booking: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 14, 4),
              child: Row(
                children: [
                  if (widget.showBack)
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, size: 30),
                    )
                  else
                    const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'My Bookings',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  _TabPill(
                    label: 'Test Drives',
                    selected: _tab == BookingType.testDrive,
                    onTap: () => setState(() => _tab = BookingType.testDrive),
                  ),
                  const SizedBox(width: 10),
                  _TabPill(
                    label: 'Services',
                    selected: _tab == BookingType.service,
                    onTap: () => setState(() => _tab = BookingType.service),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<BookingItem>>(
                stream: _stream,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Could not load bookings:\n${snap.error}',
                            textAlign: TextAlign.center),
                      ),
                    );
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list =
                      snap.data!.where((b) => b.type == _tab).toList();
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        _tab == BookingType.testDrive
                            ? 'You have no test drives yet.'
                            : 'You have no service bookings yet.',
                        style: const TextStyle(
                            fontSize: 17, color: AppColors.textGrey),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _BookingCard(
                      booking: list[i],
                      onCancel: () => _cancel(list[i]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: PrimaryButton(
                label: 'Book a Service',
                height: 52,
                radius: 26,
                fontSize: 18,
                onPressed: () =>
                    pushScreen(context, const ServiceBookingScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? Colors.black : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.onCancel});
  final BookingItem booking;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final isDrive = b.type == BookingType.testDrive;
    final image = CarStore.byId(b.carId)?.image ?? b.image;
    final canCancel = b.status == 'Pending' || b.status == 'Confirmed';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 84,
                height: 56,
                child: isDrive
                    ? CarImage(asset: image, fit: BoxFit.contain, radius: 8)
                    : Container(
                        decoration: BoxDecoration(
                          color: AppColors.serviceIconBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.build_outlined, size: 30),
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
                    const SizedBox(height: 3),
                    Text(
                      '${formatDate(b.date)}, ${b.time}',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${b.code} - ${b.typeLabel}',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              StatusChip(b.status),
            ],
          ),
          if (canCancel) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Cancel booking'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

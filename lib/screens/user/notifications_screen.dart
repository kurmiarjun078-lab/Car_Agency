import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../data/models.dart';
import '../../services/auth_service.dart';
import '../../services/db_service.dart';

/// Booking updates for the logged-in user (from the bookings collections).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final Stream<List<BookingItem>> _stream = DbService.instance
      .watchBookings(userId: AuthService.instance.currentUser?.uid ?? '-');

  (IconData, Color, String) _describe(BookingItem b) {
    final what = b.type == BookingType.testDrive
        ? 'test drive for ${b.title}'
        : '${b.title} service';
    final when = '${formatDate(b.date)}, ${b.time}';
    switch (b.status) {
      case 'Confirmed':
        return (Icons.check_circle, const Color(0xFF1565C0),
            'Your $what is confirmed for $when.');
      case 'Completed':
        return (Icons.verified, const Color(0xFF2E7D32),
            'Your $what ($when) is completed. Thank you!');
      case 'Cancelled':
        return (Icons.cancel, const Color(0xFFC62828),
            'Your $what ($when) was cancelled.');
      default:
        return (Icons.schedule, const Color(0xFFE65100),
            'Your $what request for $when is waiting for confirmation.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
      ),
      body: StreamBuilder<List<BookingItem>>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Could not load notifications: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data!;
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'There are no notifications yet.',
                style: TextStyle(fontSize: 17, color: AppColors.textGrey),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (_, i) {
              final (icon, color, text) = _describe(list[i]);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(text, style: const TextStyle(fontSize: 15.5, height: 1.35)),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

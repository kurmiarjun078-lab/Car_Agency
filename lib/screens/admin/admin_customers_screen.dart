import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../data/models.dart';
import '../../services/db_service.dart';
import '../../widgets/car_image.dart';
import '../../widgets/form_fields.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  late final Stream<List<AppUser>> _users = DbService.instance.watchCustomers();
  late final Stream<List<BookingItem>> _bookings =
      DbService.instance.watchBookings();
  String _query = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 28, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'MANAGE CUSTOMERS',
                    style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SearchPill(
                        hint: 'Search customers...',
                        radius: 16,
                        height: 48,
                        color: const Color(0xFFEDEDEF),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list, size: 30),
                      onSelected: (value) => setState(() => _filter = value),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'All', child: Text('All Customers')),
                        PopupMenuItem(value: 'Active', child: Text('With bookings')),
                        PopupMenuItem(value: 'New', child: Text('Joined last 30 days')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AppUser>>(
              stream: _users,
              builder: (context, userSnap) {
                if (userSnap.hasError) {
                  return Center(
                      child: Text('Could not load customers: ${userSnap.error}'));
                }
                if (!userSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StreamBuilder<List<BookingItem>>(
                  stream: _bookings,
                  builder: (context, bookingSnap) {
                    final counts = <String, int>{};
                    for (final b in bookingSnap.data ?? const <BookingItem>[]) {
                      counts[b.userId] = (counts[b.userId] ?? 0) + 1;
                    }
                    final cutoff =
                        DateTime.now().subtract(const Duration(days: 30));
                    final customers = userSnap.data!.where((c) {
                      final matchesQuery = c.name.toLowerCase().contains(q) ||
                          c.email.toLowerCase().contains(q) ||
                          c.phone.contains(q);
                      final matchesFilter = switch (_filter) {
                        'Active' => (counts[c.uid] ?? 0) > 0,
                        'New' => c.createdAt != null && c.createdAt!.isAfter(cutoff),
                        _ => true,
                      };
                      return matchesQuery && matchesFilter;
                    }).toList()
                      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

                    if (customers.isEmpty) {
                      return const Center(child: Text('No customers found.'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                      itemCount: customers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _CustomerCard(
                        customer: customers[i],
                        bookings: counts[customers[i].uid] ?? 0,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer, required this.bookings});
  final AppUser customer;
  final int bookings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Avatar(
            size: 44,
            name: customer.name.isEmpty ? customer.email : customer.name,
            photo: customer.photo,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name.isEmpty ? '(no name)' : customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 2),
                Text(
                  customer.phone.isEmpty ? customer.email : customer.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$bookings Bookings',
            style: const TextStyle(fontSize: 17, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

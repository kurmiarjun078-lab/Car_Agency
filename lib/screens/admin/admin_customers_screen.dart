import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/car_image.dart';
import '../../widgets/form_fields.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  String _query = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final customers = MockData.customers.where((c) {
      final matchesQuery = c.name.toLowerCase().contains(q) || c.phone.contains(q);
      final matchesFilter = switch (_filter) {
        'VIP' => c.bookings >= 8,
        'Recent' => c.bookings >= 5,
        _ => true,
      };
      return matchesQuery && matchesFilter;
    }).toList();

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
                        PopupMenuItem(value: 'VIP', child: Text('VIP Customers')),
                        PopupMenuItem(value: 'Recent', child: Text('Recent Buyers')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: customers.isEmpty
                ? const Center(child: Text('No customers found'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                    itemCount: customers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _CustomerCard(customer: customers[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});
  final Customer customer;

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
          Avatar(size: 44, asset: customer.avatarAsset),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 2),
                Text(
                  customer.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${customer.bookings} Bookings',
            style: const TextStyle(fontSize: 17, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

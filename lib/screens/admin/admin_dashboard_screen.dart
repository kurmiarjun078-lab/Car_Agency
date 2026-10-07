import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/car_image.dart';
import 'admin_add_car_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgAdmin,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ADMIN DASHBOARD',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, size: 34),
                    onSelected: (value) {
                      switch (value) {
                        case 'Overview':
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dashboard overview refreshed')),
                          );
                          break;
                        case 'Add New Car':
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AdminAddCarScreen(),
                            ),
                          );
                          break;
                        case 'Customers':
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Customer management opened')),
                          );
                          break;
                        default:
                          break;
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'Overview', child: Text('Overview')),
                      PopupMenuItem(value: 'Add New Car', child: Text('Add New Car')),
                      PopupMenuItem(value: 'Customers', child: Text('Customers')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _AdminCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(label: 'Total Cars', value: '250'),
                        ),
                        _StatDivider(vertical: true),
                        Expanded(
                          child:
                              _StatCard(label: 'Total Bookings', value: '580'),
                        ),
                      ],
                    ),
                    _StatDivider(),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                              label: 'Total Customers', value: '430'),
                        ),
                        _StatDivider(vertical: true),
                        Expanded(
                          child: _StatCard(label: 'Revenue', value: '₹2.45 Cr'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const _RecentOrders(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard(
      {required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? 1 : null,
      height: vertical ? 58 : 1,
      color: AppColors.divider,
    );
  }
}

class _RecentOrders extends StatelessWidget {
  const _RecentOrders();

  @override
  Widget build(BuildContext context) {
    const orders = MockData.recentOrders;
    return _AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Orders',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < orders.length; i++) ...[
            _OrderRow(order: orders[i]),
            if (i != orders.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: AppColors.divider),
              ),
          ],
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});
  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CarImage(asset: order.imageAsset, radius: 8),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.carName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 19),
              ),
              Text(
                formatPrice(order.price),
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _StatusChip(status: order.status),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color bg;
    late final Color fg;
    late final Color dot;
    switch (status) {
      case OrderStatus.completed:
        label = 'Completed';
        bg = AppColors.successBg;
        fg = AppColors.successText;
        dot = AppColors.successDot;
      case OrderStatus.delivered:
        label = 'Delivered';
        bg = AppColors.successBg;
        fg = AppColors.successText;
        dot = AppColors.successDot;
      case OrderStatus.pending:
        label = 'Pending';
        bg = AppColors.pendingBg;
        fg = AppColors.pendingText;
        dot = AppColors.pendingDot;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(label, style: TextStyle(fontSize: 16, color: fg)),
        ],
      ),
    );
  }
}

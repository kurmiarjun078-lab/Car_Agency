import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../data/car_store.dart';
import '../../data/models.dart';
import '../../services/db_service.dart';
import '../../widgets/car_image.dart';
import '../../widgets/status_chip.dart';
import 'admin_add_car_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, required this.onNavigate});

  /// Switches the admin bottom-nav tab (1 Cars, 2 Bookings, 3 Customers).
  final ValueChanged<int> onNavigate;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final Stream<List<BookingItem>> _bookings =
      DbService.instance.watchBookings();
  late final Stream<List<AppUser>> _customers =
      DbService.instance.watchCustomers();

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
                        case 'Add New Car':
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AdminAddCarScreen(),
                            ),
                          );
                        case 'Manage Cars':
                          widget.onNavigate(1);
                        case 'Bookings':
                          widget.onNavigate(2);
                        case 'Customers':
                          widget.onNavigate(3);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'Add New Car', child: Text('Add New Car')),
                      PopupMenuItem(value: 'Manage Cars', child: Text('Manage Cars')),
                      PopupMenuItem(value: 'Bookings', child: Text('Bookings')),
                      PopupMenuItem(value: 'Customers', child: Text('Customers')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              StreamBuilder<List<BookingItem>>(
                stream: _bookings,
                builder: (context, bookingSnap) {
                  final bookings = bookingSnap.data ?? const <BookingItem>[];
                  final revenue = bookings
                      .where((b) => b.status == 'Completed')
                      .fold<int>(0, (sum, b) => sum + b.price);
                  return Column(
                    children: [
                      _AdminCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ValueListenableBuilder<List<Car>>(
                                    valueListenable: CarStore.items,
                                    builder: (_, cars, __) => _StatCard(
                                      label: 'Total Cars',
                                      value: '${cars.length}',
                                    ),
                                  ),
                                ),
                                const _StatDivider(vertical: true),
                                Expanded(
                                  child: _StatCard(
                                    label: 'Total Bookings',
                                    value: '${bookings.length}',
                                  ),
                                ),
                              ],
                            ),
                            const _StatDivider(),
                            Row(
                              children: [
                                Expanded(
                                  child: StreamBuilder<List<AppUser>>(
                                    stream: _customers,
                                    builder: (_, snap) => _StatCard(
                                      label: 'Total Customers',
                                      value: '${snap.data?.length ?? 0}',
                                    ),
                                  ),
                                ),
                                const _StatDivider(vertical: true),
                                Expanded(
                                  child: _StatCard(
                                    label: 'Revenue',
                                    value: formatCompactPrice(revenue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _RecentOrders(
                        bookings: bookings.take(4).toList(),
                        loading: !bookingSnap.hasData && !bookingSnap.hasError,
                        error: bookingSnap.error,
                        onSeeAll: () => widget.onNavigate(2),
                      ),
                    ],
                  );
                },
              ),
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
  const _RecentOrders({
    required this.bookings,
    required this.loading,
    required this.onSeeAll,
    this.error,
  });
  final List<BookingItem> bookings;
  final bool loading;
  final Object? error;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return _AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent Bookings',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),
              ),
              TextButton(onPressed: onSeeAll, child: const Text('See all')),
            ],
          ),
          const SizedBox(height: 6),
          if (error != null)
            Text('Could not load data: $error',
                style: const TextStyle(color: Colors.red))
          else if (loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (bookings.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('There are no bookings yet.',
                  style: TextStyle(color: AppColors.textMuted)),
            )
          else
            for (var i = 0; i < bookings.length; i++) ...[
              _OrderRow(booking: bookings[i]),
              if (i != bookings.length - 1)
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
  const _OrderRow({required this.booking});
  final BookingItem booking;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final image = CarStore.byId(b.carId)?.image ?? b.image;
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: b.type == BookingType.testDrive
              ? CarImage(asset: image, radius: 8)
              : Container(
                  decoration: BoxDecoration(
                    color: AppColors.serviceIconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.build_outlined),
                ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                b.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '${b.customer} - ${formatPrice(b.price)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        StatusChip(b.status),
      ],
    );
  }
}

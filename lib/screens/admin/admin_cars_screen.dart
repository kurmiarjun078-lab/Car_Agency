import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../data/car_store.dart';
import '../../data/models.dart';
import '../../services/db_service.dart';
import '../../widgets/car_image.dart';
import '../../widgets/primary_button.dart';
import 'admin_add_car_screen.dart';

/// Admin "Cars" tab: all cars with search, add, edit, delete.
class AdminCarsScreen extends StatefulWidget {
  const AdminCarsScreen({super.key});

  @override
  State<AdminCarsScreen> createState() => _AdminCarsScreenState();
}

class _AdminCarsScreenState extends State<AdminCarsScreen> {
  String _query = '';
  bool _seeding = false;

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _openForm([Car? car]) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AdminAddCarScreen(car: car)),
    );
  }

  Future<void> _delete(Car car) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete car?'),
        content: Text('${car.name} will be deleted permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await DbService.instance.deleteCar(car.id);
      if (mounted) _toast('${car.name} was deleted.');
    } catch (e) {
      if (mounted) _toast('Could not delete car: $e');
    }
  }

  Future<void> _seed() async {
    setState(() => _seeding = true);
    try {
      await DbService.instance.seedDemoCars();
      if (mounted) _toast('Sample cars added.');
    } catch (e) {
      if (mounted) _toast('Could not add sample cars: $e');
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgAdmin,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'MANAGE CARS',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _openForm(),
                    style: FilledButton.styleFrom(backgroundColor: Colors.black),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: TextField(
                onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search cars...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Car>>(
                valueListenable: CarStore.items,
                builder: (context, all, _) {
                  if (all.isEmpty) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: CarStore.loading,
                      builder: (context, loading, _) {
                        if (loading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder<String?>(
                                  valueListenable: CarStore.error,
                                  builder: (_, err, __) => Text(
                                    err ?? 'There are no cars yet.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                PrimaryButton(
                                  label: _seeding
                                      ? 'Adding...'
                                      : 'Load 15 sample cars',
                                  onPressed: _seeding ? () {} : _seed,
                                  height: 52,
                                  radius: 14,
                                  fontSize: 17,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  final cars = all
                      .where((c) => '${c.name} ${c.brand}'
                          .toLowerCase()
                          .contains(_query))
                      .toList();
                  if (cars.isEmpty) {
                    return const Center(child: Text('No cars found.'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                    itemCount: cars.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _CarRow(
                      car: cars[i],
                      onEdit: () => _openForm(cars[i]),
                      onDelete: () => _delete(cars[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarRow extends StatelessWidget {
  const _CarRow({
    required this.car,
    required this.onEdit,
    required this.onDelete,
  });
  final Car car;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 86,
            height: 60,
            child: CarImage(asset: car.image, radius: 10),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${car.brand} - ${car.category}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                Text(
                  formatPrice(car.price, symbol: car.currency),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}

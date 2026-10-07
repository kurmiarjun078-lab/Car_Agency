import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/wishlist_store.dart';

/// Heart that reads/writes the shared [WishlistStore].
class HeartButton extends StatelessWidget {
  const HeartButton({
    super.key,
    required this.car,
    this.color = Colors.white,
    this.size = 26,
  });

  final Car car;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Car>>(
      valueListenable: WishlistStore.items,
      builder: (context, _, __) {
        final liked = WishlistStore.contains(car.id);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => WishlistStore.toggle(car),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              size: size,
              color: liked ? const Color(0xFFE53935) : color,
            ),
          ),
        );
      },
    );
  }
}

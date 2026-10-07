import 'package:flutter/foundation.dart';
import 'mock_data.dart';
import 'models.dart';

/// Tiny in-memory wishlist shared by every heart button.
/// Swap for Firestore later without touching the widgets.
class WishlistStore {
  WishlistStore._();

  static final ValueNotifier<List<Car>> items =
      ValueNotifier<List<Car>>(List<Car>.of(MockData.wishlistSeed));

  static bool contains(String id) => items.value.any((c) => c.id == id);

  static void toggle(Car car) {
    final list = List<Car>.of(items.value);
    final i = list.indexWhere((c) => c.id == car.id);
    if (i >= 0) {
      list.removeAt(i);
    } else {
      list.add(car);
    }
    items.value = list;
  }
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'models.dart';

/// Live copy of the Firestore `cars` collection, shared by all screens.
/// Started/stopped by AuthService when the user signs in or out.
class CarStore {
  CarStore._();

  static final ValueNotifier<List<Car>> items =
      ValueNotifier<List<Car>>(const <Car>[]);
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  static final ValueNotifier<String?> error = ValueNotifier<String?>(null);

  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  static void start() {
    if (_sub != null) return;
    loading.value = true;
    error.value = null;
    _sub = FirebaseFirestore.instance.collection('cars').snapshots().listen(
      (snap) {
        final list = snap.docs.map((d) => Car.fromMap(d.id, d.data())).toList()
          ..sort((a, b) {
            final x = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final y = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return y.compareTo(x);
          });
        items.value = list;
        loading.value = false;
        error.value = null;
      },
      onError: (Object e) {
        loading.value = false;
        error.value = 'Could not load cars: $e';
      },
    );
  }

  static void stop() {
    _sub?.cancel();
    _sub = null;
    items.value = const <Car>[];
    loading.value = true;
    error.value = null;
  }

  static Car? byId(String? id) {
    if (id == null) return null;
    for (final c in items.value) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Cars flagged "featured"; falls back to the first few cars.
  static List<Car> get featured {
    final f = items.value.where((c) => c.featured).toList();
    return f.isNotEmpty ? f : items.value.take(3).toList();
  }
}

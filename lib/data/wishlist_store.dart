import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'car_store.dart';
import 'models.dart';

/// Wishlist saved in Firestore at users/{uid}/wishlist/{carId}.
class WishlistStore {
  WishlistStore._();

  static final ValueNotifier<List<Car>> items =
      ValueNotifier<List<Car>>(const <Car>[]);

  static Set<String> _ids = <String>{};
  static String? _uid;
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  static CollectionReference<Map<String, dynamic>> _col(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('wishlist');

  static void start(String uid) {
    stop();
    _uid = uid;
    CarStore.items.addListener(_rebuild);
    _sub = _col(uid).snapshots().listen(
      (snap) {
        _ids = snap.docs.map((d) => d.id).toSet();
        _rebuild();
      },
      onError: (Object _) {},
    );
  }

  static void stop() {
    _sub?.cancel();
    _sub = null;
    CarStore.items.removeListener(_rebuild);
    _uid = null;
    _ids = <String>{};
    items.value = const <Car>[];
  }

  static void _rebuild() {
    items.value = CarStore.items.value.where((c) => _ids.contains(c.id)).toList();
  }

  static bool contains(String id) => _ids.contains(id);

  static Future<void> toggle(Car car) async {
    final uid = _uid;
    if (uid == null) return;
    final ref = _col(uid).doc(car.id);
    final wasLiked = _ids.contains(car.id);
    // Update the UI first, then save; undo if saving fails.
    _ids = wasLiked ? ({..._ids}..remove(car.id)) : {..._ids, car.id};
    _rebuild();
    try {
      if (wasLiked) {
        await ref.delete();
      } else {
        await ref.set({
          'carId': car.id,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {
      _ids = wasLiked ? {..._ids, car.id} : ({..._ids}..remove(car.id));
      _rebuild();
    }
  }
}

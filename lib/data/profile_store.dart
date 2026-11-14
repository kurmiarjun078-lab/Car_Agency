import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'models.dart';

/// Profile of the logged-in user (users/{uid}), kept live.
class ProfileStore {
  ProfileStore._();

  static final ValueNotifier<AppUser?> user = ValueNotifier<AppUser?>(null);
  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;

  static void start(String uid) {
    stop();
    _sub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
      (doc) {
        final data = doc.data();
        user.value = data == null ? null : AppUser.fromMap(doc.id, data);
      },
      onError: (Object _) {},
    );
  }

  static void stop() {
    _sub?.cancel();
    _sub = null;
    user.value = null;
  }
}

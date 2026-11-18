import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/app_data.dart';
import '../data/car_store.dart';
import '../data/models.dart';
import '../data/profile_store.dart';

typedef CarRatingSummary = ({
  double average,
  int count,
  int? userRating,
});

/// All Firestore reads/writes for cars, bookings and customers.
class DbService {
  DbService._();
  static final instance = DbService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  User get _user {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) throw StateError('Please sign in first.');
    return u;
  }

  // ----------------------------------------------------------------- Cars
  Future<void> addCar(Car car) => _db.collection('cars').add({
        ...car.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> updateCar(Car car) =>
      _db.collection('cars').doc(car.id).update(car.toMap());

  Future<void> deleteCar(String id) => _db.collection('cars').doc(id).delete();

  Stream<CarRatingSummary> watchCarRatings(Car car) {
    final userId = _user.uid;
    return _db
        .collection('cars')
        .doc(car.id)
        .collection('ratings')
        .snapshots()
        .map((snapshot) {
      var count = car.reviews > 0 ? car.reviews : 0;
      var total = car.rating * count;
      int? userRating;

      for (final doc in snapshot.docs) {
        final value = doc.data()['rating'];
        if (value is! int || value < 1 || value > 5) continue;
        count++;
        total += value;
        if (doc.id == userId) userRating = value;
      }

      return (
        average: count == 0 ? 0.0 : total / count,
        count: count,
        userRating: userRating,
      );
    });
  }

  Future<void> rateCar(String carId, int rating) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError.value(rating, 'rating', 'Must be between 1 and 5');
    }
    return _db
        .collection('cars')
        .doc(carId)
        .collection('ratings')
        .doc(_user.uid)
        .set({
      'rating': rating,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Writes the built-in sample cars. Safe to run again because IDs are stable.
  Future<void> seedDemoCars() async {
    final batch = _db.batch();
    final now = DateTime.now();
    var i = 0;
    for (final c in AppData.seedCars) {
      batch.set(_db.collection('cars').doc(c.id), {
        ...c.toMap(),
        // keeps the sample order stable (newest first in the app)
        'createdAt': Timestamp.fromDate(now.subtract(Duration(seconds: i++))),
      });
    }
    await batch.commit();
  }

  // ------------------------------------------------------------- Bookings
  Future<({String name, String phone})> _who() async {
    final u = _user;
    var p = ProfileStore.user.value;
    if (p == null) {
      final doc = await _db.collection('users').doc(u.uid).get();
      final d = doc.data();
      if (d != null) p = AppUser.fromMap(u.uid, d);
    }
    final name = (p?.name.isNotEmpty ?? false)
        ? p!.name
        : (u.displayName?.isNotEmpty ?? false)
            ? u.displayName!
            : (u.email ?? 'Customer');
    return (name: name, phone: p?.phone ?? '');
  }

  Future<void> bookTestDrive({
    required Car car,
    required DateTime date,
    required String time,
  }) async {
    final u = _user;
    final who = await _who();
    await _db.collection('bookings').add({
      'userId': u.uid,
      'customer': who.name,
      'phone': who.phone,
      'carId': car.id,
      'title': car.name,
      'image': car.imageAsset ?? '',
      'price': car.price,
      'location': '${AppData.dealerName}, ${AppData.dealerLocation}',
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'time': time,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> bookService({
    required ServiceItem service,
    required DateTime date,
    required String time,
  }) async {
    final u = _user;
    final who = await _who();
    await _db.collection('serviceBookings').add({
      'userId': u.uid,
      'customer': who.name,
      'phone': who.phone,
      'title': service.name,
      'image': '',
      'price': service.price,
      'location': '${AppData.dealerName}, ${AppData.dealerLocation}',
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'time': time,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setBookingStatus(BookingItem b, String status) =>
      _db.collection(b.collection).doc(b.id).update({'status': status});

  /// Test drives + service bookings merged, newest first.
  /// [userId] null = everything (admin). Create the stream once (initState).
  Stream<List<BookingItem>> watchBookings({String? userId}) {
    late StreamController<List<BookingItem>> controller;
    var drives = <BookingItem>[];
    var services = <BookingItem>[];
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subA;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subB;

    void emit() {
      final all = [...drives, ...services]
        ..sort((a, b) => b.sortKey.compareTo(a.sortKey));
      if (!controller.isClosed) controller.add(all);
    }

    Query<Map<String, dynamic>> query(String name) {
      Query<Map<String, dynamic>> q = _db.collection(name);
      if (userId != null) q = q.where('userId', isEqualTo: userId);
      return q;
    }

    controller = StreamController<List<BookingItem>>(
      onListen: () {
        subA = query('bookings').snapshots().listen((s) {
          drives = s.docs
              .map((d) =>
                  BookingItem.fromMap(d.id, BookingType.testDrive, d.data()))
              .toList();
          emit();
        }, onError: (Object e) => controller.addError(e));
        subB = query('serviceBookings').snapshots().listen((s) {
          services = s.docs
              .map((d) =>
                  BookingItem.fromMap(d.id, BookingType.service, d.data()))
              .toList();
          emit();
        }, onError: (Object e) => controller.addError(e));
      },
      onCancel: () {
        subA?.cancel();
        subB?.cancel();
      },
    );
    return controller.stream;
  }

  // ------------------------------------------------------------ Customers
  Stream<List<AppUser>> watchCustomers() => _db
      .collection('users')
      .where('role', isEqualTo: 'user')
      .snapshots()
      .map((s) => s.docs.map((d) => AppUser.fromMap(d.id, d.data())).toList());

  /// Handy for screens that only have a car id.
  Car? carById(String? id) => CarStore.byId(id);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/formatters.dart';

DateTime? _toDate(dynamic v) {
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  return null;
}

class CarSpec {
  const CarSpec(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class CarFeature {
  const CarFeature(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// Picks an icon for a feature name typed by the admin.
IconData featureIcon(String label) {
  final l = label.toLowerCase();
  if (l.contains('audio') || l.contains('music') || l.contains('sound')) {
    return Icons.music_note_outlined;
  }
  if (l.contains('pilot') || l.contains('navigation') || l.contains('gps')) {
    return Icons.navigation_outlined;
  }
  if (l.contains('roof') || l.contains('sun')) return Icons.wb_sunny_outlined;
  if (l.contains('seat')) return Icons.airline_seat_recline_normal_outlined;
  if (l.contains('driving') || l.contains('drive')) {
    return Icons.directions_car_outlined;
  }
  if (l.contains('camera')) return Icons.camera_alt_outlined;
  if (l.contains('climate') || l.contains('air con')) return Icons.ac_unit;
  return Icons.check_circle_outline;
}

class Car {
  const Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.currency = '₹',
    this.rating = 4.5,
    this.reviews = 0,
    this.fuel = 'Petrol',
    this.transmission = 'Automatic',
    this.category = 'Sedan',
    this.seats = 5,
    this.colorIndex,
    this.engine = '',
    this.horsepower = '',
    this.mileage = '',
    this.acceleration = '',
    this.topSpeed = '',
    this.description = '',
    this.features = const [],
    this.imageAsset,
    this.images = const [],
    this.featured = false,
    this.createdAt,
  });

  final String id;
  final String name;
  final String brand;
  final int price;
  final String currency;
  final double rating;
  final int reviews;
  final String fuel;
  final String transmission;
  final String category;
  final int seats;

  /// Index into AppData.filterColors (null = not set).
  final int? colorIndex;
  final String engine;
  final String horsepower;
  final String mileage;
  final String acceleration;
  final String topSpeed;
  final String description;
  final List<String> features;

  /// Bundled asset path, e.g. 'assets/cars/bmw_m4.png' (used by sample cars).
  final String? imageAsset;

  /// Photos uploaded by the admin, stored as base64 strings.
  final List<String> images;
  final bool featured;
  final DateTime? createdAt;

  String get priceLabel => formatPrice(price, symbol: currency);

  /// Main picture: an uploaded photo if there is one, otherwise the asset.
  String? get image => images.isNotEmpty ? images.first : imageAsset;

  /// Every picture, for the gallery.
  List<String> get allImages =>
      images.isNotEmpty ? images : (imageAsset == null ? const [] : [imageAsset!]);

  List<CarSpec> get specs => [
        if (engine.isNotEmpty) CarSpec(Icons.settings_outlined, 'Engine', engine),
        if (horsepower.isNotEmpty)
          CarSpec(Icons.bolt_outlined, 'Horsepower', horsepower),
        if (mileage.isNotEmpty) CarSpec(Icons.map_outlined, 'Mileage', mileage),
        if (acceleration.isNotEmpty)
          CarSpec(Icons.speed_outlined, '0-60 mph', acceleration),
        if (topSpeed.isNotEmpty)
          CarSpec(Icons.timer_outlined, 'Top Speed', topSpeed),
        CarSpec(Icons.event_seat_outlined, 'Seats', '$seats'),
        CarSpec(Icons.local_gas_station_outlined, 'Fuel', fuel),
        CarSpec(Icons.tune, 'Gearbox', transmission),
      ];

  List<CarFeature> get featureItems =>
      [for (final f in features) CarFeature(featureIcon(f), f)];

  factory Car.fromMap(String id, Map<String, dynamic> m) {
    return Car(
      id: id,
      name: (m['name'] as String?) ?? 'Unnamed car',
      brand: (m['brand'] as String?) ?? '',
      price: (m['price'] as num?)?.toInt() ?? 0,
      currency: (m['currency'] as String?) ?? '₹',
      rating: (m['rating'] as num?)?.toDouble() ?? 4.5,
      reviews: (m['reviews'] as num?)?.toInt() ?? 0,
      fuel: (m['fuel'] as String?) ?? 'Petrol',
      transmission: (m['transmission'] as String?) ?? 'Automatic',
      category: (m['category'] as String?) ?? 'Sedan',
      seats: (m['seats'] as num?)?.toInt() ?? 5,
      colorIndex: (m['colorIndex'] as num?)?.toInt(),
      engine: (m['engine'] as String?) ?? '',
      horsepower: (m['horsepower'] as String?) ?? '',
      mileage: (m['mileage'] as String?) ?? '',
      acceleration: (m['acceleration'] as String?) ?? '',
      topSpeed: (m['topSpeed'] as String?) ?? '',
      description: (m['description'] as String?) ?? '',
      features: List<String>.from((m['features'] as List?) ?? const []),
      imageAsset: m['imageAsset'] as String?,
      images: List<String>.from((m['images'] as List?) ?? const []),
      featured: (m['featured'] as bool?) ?? false,
      createdAt: _toDate(m['createdAt']),
    );
  }

  /// Firestore document body (createdAt is added by the service).
  Map<String, dynamic> toMap() => {
        'name': name,
        'brand': brand,
        'price': price,
        'currency': currency,
        'rating': rating,
        'reviews': reviews,
        'fuel': fuel,
        'transmission': transmission,
        'category': category,
        'seats': seats,
        'colorIndex': colorIndex,
        'engine': engine,
        'horsepower': horsepower,
        'mileage': mileage,
        'acceleration': acceleration,
        'topSpeed': topSpeed,
        'description': description,
        'features': features,
        'imageAsset': imageAsset,
        'images': images,
        'featured': featured,
      };
}

class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.photo = '',
    this.role = 'user',
    this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String role;
  final DateTime? createdAt;

  bool get isAdmin => role == 'admin';

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
        uid: uid,
        name: (m['name'] as String?) ?? '',
        email: (m['email'] as String?) ?? '',
        phone: (m['phone'] as String?) ?? '',
        photo: (m['photo'] as String?) ?? '',
        role: (m['role'] as String?) ?? 'user',
        createdAt: _toDate(m['createdAt']),
      );
}

class ServiceItem {
  const ServiceItem(this.icon, this.name, this.price);
  final IconData icon;
  final String name;
  final int price;
}

class CategoryItem {
  const CategoryItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

enum BookingType { testDrive, service }

/// One row of the "bookings" (test drives) or "serviceBookings" collection.
class BookingItem {
  const BookingItem({
    required this.id,
    required this.type,
    required this.userId,
    required this.customer,
    required this.title,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    this.phone = '',
    this.carId,
    this.image,
    this.location = '',
    this.createdAt,
  });

  static const List<String> statuses = [
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled',
  ];

  final String id;
  final BookingType type;
  final String userId;
  final String customer;
  final String phone;
  final String title; // car name or service name
  final String? carId;
  final String? image;
  final String location;
  final DateTime date;
  final String time;
  final int price;
  final String status;
  final DateTime? createdAt;

  String get collection =>
      type == BookingType.testDrive ? 'bookings' : 'serviceBookings';

  String get typeLabel =>
      type == BookingType.testDrive ? 'Test Drive' : 'Service';

  String get code {
    final short = id.length < 5 ? id : id.substring(0, 5);
    return 'BK-${short.toUpperCase()}';
  }

  DateTime get sortKey => createdAt ?? DateTime.now();

  factory BookingItem.fromMap(
      String id, BookingType type, Map<String, dynamic> m) {
    return BookingItem(
      id: id,
      type: type,
      userId: (m['userId'] as String?) ?? '',
      customer: (m['customer'] as String?) ?? 'Customer',
      phone: (m['phone'] as String?) ?? '',
      title: (m['title'] as String?) ?? '',
      carId: m['carId'] as String?,
      image: (m['image'] as String?)?.isEmpty ?? true
          ? null
          : m['image'] as String?,
      location: (m['location'] as String?) ?? '',
      date: _toDate(m['date']) ?? DateTime.now(),
      time: (m['time'] as String?) ?? '',
      price: (m['price'] as num?)?.toInt() ?? 0,
      status: (m['status'] as String?) ?? 'Pending',
      createdAt: _toDate(m['createdAt']),
    );
  }
}

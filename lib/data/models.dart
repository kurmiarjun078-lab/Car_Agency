import 'package:flutter/material.dart';
import '../core/formatters.dart';

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

class CarDefaults {
  CarDefaults._();

  static const List<CarSpec> specs = [
    CarSpec(Icons.settings_outlined, 'Engine', 'Electric Motor'),
    CarSpec(Icons.bolt_outlined, 'Horsepower', '1020 HP'),
    CarSpec(Icons.map_outlined, 'Mileage', '396 miles'),
    CarSpec(Icons.speed_outlined, '0-60 mph', '1.99 s'),
    CarSpec(Icons.timer_outlined, 'Top Speed', '200 mph'),
    CarSpec(Icons.event_seat_outlined, 'Seats', '5'),
  ];

  static const List<CarFeature> features = [
    CarFeature(Icons.navigation_outlined, 'Autopilot'),
    CarFeature(Icons.music_note_outlined, 'Premium Audio'),
    CarFeature(Icons.directions_car_outlined, 'Full Self-Driving'),
    CarFeature(Icons.wb_sunny_outlined, 'Glass Roof'),
    CarFeature(Icons.airline_seat_recline_normal_outlined, 'Heated Seats'),
  ];
}

class Car {
  const Car({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.currency = '₹',
    this.rating = 4.9,
    this.reviews = 120,
    this.fuel = 'Petrol',
    this.transmission = 'Automatic',
    this.imageAsset,
    this.specs = CarDefaults.specs,
    this.features = CarDefaults.features,
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

  /// e.g. 'assets/cars/bmw_m4.png'. When missing, a placeholder is drawn.
  final String? imageAsset;
  final List<CarSpec> specs;
  final List<CarFeature> features;

  String get priceLabel => formatPrice(price, symbol: currency);
}

class Customer {
  const Customer(this.name, this.phone, this.bookings, {this.avatarAsset});
  final String name;
  final String phone;
  final int bookings;
  final String? avatarAsset;
}

class ServiceItem {
  const ServiceItem(this.icon, this.name, this.price);
  final IconData icon;
  final String name;
  final int price;
}

enum OrderStatus { completed, pending, delivered }

class OrderItem {
  const OrderItem(this.carName, this.price, this.status, {this.imageAsset});
  final String carName;
  final int price;
  final OrderStatus status;
  final String? imageAsset;
}

class CategoryItem {
  const CategoryItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

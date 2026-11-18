import 'package:flutter/material.dart';
import 'models.dart';

/// Static app content (menus, option lists) plus the sample cars that the
/// admin can load into Firestore with one tap.
class AppData {
  AppData._();

  static const List<CategoryItem> categories = [
    CategoryItem('SUV', Icons.airport_shuttle_outlined),
    CategoryItem('Sedan', Icons.directions_car_outlined),
    CategoryItem('Luxury', Icons.diamond_outlined),
    CategoryItem('Sports', Icons.speed_outlined),
    CategoryItem('Electric', Icons.electric_car_outlined),
  ];

  static List<String> get categoryNames =>
      [for (final c in categories) c.label];

  /// name -> logo asset (assets/brands/)
  static const Map<String, String> popularBrands = {
    'BMW': 'assets/brands/bmw.png',
    'Audi': 'assets/brands/audi.png',
    'Mercedes-Benz': 'assets/brands/mercedes_benz.png',
    'Toyota': 'assets/brands/toyota.png',
    'Honda': 'assets/brands/honda.png',
    'Nissan': 'assets/brands/nissan.png',
  };

  static const List<String> brands = [
    'Audi', 'BMW', 'Honda', 'Mercedes-Benz', 'Nissan', 'Tesla', 'Toyota',
    'Volvo', 'Porsche', 'Lamborghini', 'Ferrari', 'Aston Martin', 'McLaren',
  ];
  static const List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];
  static const List<String> transmissions = ['Automatic', 'Manual'];
  static const List<String> seatOptions = ['2', '4', '5', '7'];
  static const List<Color> filterColors = [
    Color(0xFF000000),
    Color(0xFFC4C5C9),
    Color(0xFFFFFFFF),
    Color(0xFFD92B2B),
    Color(0xFF1356C9),
  ];

  static const List<ServiceItem> services = [
    ServiceItem(Icons.build_outlined, 'Oil Change', 2500),
    ServiceItem(Icons.tire_repair_outlined, 'Wheel Alignment', 1800),
    ServiceItem(Icons.settings_outlined, 'Engine Checkup', 3500),
    ServiceItem(Icons.battery_charging_full_outlined, 'Battery Check', 1500),
  ];

  static const List<String> dealerTimes = [
    '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '02:00 PM', '04:00 PM',
  ];

  static const String dealerName = 'DriveHub Motors';
  static const String dealerLocation = 'Rajkot, Gujarat';
  static const String supportEmail = 'support@drivehub.com';
  static const String supportPhone = '+91 98000 00000';

  // ---------------------------------------------------------- Sample cars
  static const List<String> _premium = [
    'Autopilot', 'Premium Audio', 'Glass Roof', 'Heated Seats', 'Navigation',
  ];

  static const List<Car> seedCars = [
    Car(
      id: 'bmw_m4', name: 'BMW M4 Coupe', brand: 'BMW', price: 7500000,
      category: 'Sports', seats: 4, colorIndex: 4, rating: 4.8, reviews: 214,
      engine: '3.0L Twin-Turbo I6', horsepower: '503 HP', mileage: '9 km/l',
      acceleration: '3.4 s', topSpeed: '180 mph', featured: true,
      description: 'A track-ready coupe with everyday comfort.',
      features: _premium, imageAsset: 'assets/cars/bmw_m4.png',
    ),
    Car(
      id: 'audi_a8', name: 'Audi A8', brand: 'Audi', price: 6600000,
      category: 'Luxury', seats: 5, colorIndex: 1, rating: 4.9, reviews: 180,
      engine: '3.0L V6 TFSI', horsepower: '335 HP', mileage: '11 km/l',
      acceleration: '5.6 s', topSpeed: '155 mph', featured: true,
      description: 'Flagship luxury sedan with a quiet, tech-filled cabin.',
      features: _premium, imageAsset: 'assets/cars/audi_a8.png',
    ),
    Car(
      id: 'tesla_y', name: 'Tesla Model Y', brand: 'Tesla', price: 8000000,
      category: 'Electric', fuel: 'Electric', seats: 5, colorIndex: 2,
      rating: 4.9, reviews: 320, engine: 'Dual Electric Motor',
      horsepower: '384 HP', mileage: '330 miles', acceleration: '4.8 s',
      topSpeed: '135 mph', featured: true,
      description: 'Electric SUV with long range and over-the-air updates.',
      features: _premium, imageAsset: 'assets/cars/tesla_model_y.png',
    ),
    Car(
      id: 'merc_c', name: 'Mercedes C-Class', brand: 'Mercedes-Benz',
      price: 6600000, category: 'Sedan', seats: 5, colorIndex: 1, rating: 4.7,
      reviews: 150, engine: '2.0L Turbo I4', horsepower: '255 HP',
      mileage: '14 km/l', acceleration: '6.0 s', topSpeed: '130 mph',
      description: 'Compact executive sedan with a refined interior.',
      features: _premium, imageAsset: 'assets/cars/mercedes_c_class.png',
    ),
    Car(
      id: 'merc_c_black', name: 'Mercedes C-Class Black Edition',
      brand: 'Mercedes-Benz', price: 11200000, category: 'Luxury', seats: 5,
      colorIndex: 0, rating: 4.8, reviews: 96, engine: '2.0L Turbo I4',
      horsepower: '320 HP', mileage: '13 km/l', acceleration: '5.2 s',
      topSpeed: '155 mph',
      description: 'Limited black edition with AMG styling.',
      features: _premium, imageAsset: 'assets/cars/mercedes_c_class_black.png',
    ),
    Car(
      id: 'bmw_x5', name: 'BMW X5', brand: 'BMW', price: 6600000,
      category: 'SUV', fuel: 'Diesel', seats: 7, colorIndex: 0, rating: 4.6,
      reviews: 132, engine: '3.0L Diesel I6', horsepower: '340 HP',
      mileage: '12 km/l', acceleration: '5.5 s', topSpeed: '140 mph',
      description: 'Spacious premium SUV for family and long drives.',
      features: _premium, imageAsset: 'assets/cars/bmw_x5.png',
    ),
    Car(
      id: 'audi_a5', name: 'Audi A5', brand: 'Audi', price: 6500000,
      category: 'Sedan', seats: 5, colorIndex: 3, rating: 4.6, reviews: 88,
      engine: '2.0L TFSI', horsepower: '261 HP', mileage: '15 km/l',
      acceleration: '5.7 s', topSpeed: '155 mph',
      description: 'Sleek sportback with quattro all-wheel drive.',
      features: _premium, imageAsset: 'assets/cars/audi_a5.png',
    ),
    Car(
      id: 'audi_a6', name: 'Audi A6', brand: 'Audi', price: 6500000,
      category: 'Sedan', seats: 5, colorIndex: 1, rating: 4.7, reviews: 101,
      engine: '2.0L TFSI', horsepower: '261 HP', mileage: '14 km/l',
      acceleration: '6.1 s', topSpeed: '155 mph',
      description: 'Business-class comfort with sharp handling.',
      features: _premium, imageAsset: 'assets/cars/audi_a6.png',
    ),
    Car(
      id: 'tesla_plaid', name: 'Tesla Model S Plaid', brand: 'Tesla',
      price: 8200000, category: 'Electric', fuel: 'Electric', seats: 5,
      colorIndex: 2, rating: 4.9, reviews: 240, engine: 'Tri Electric Motor',
      horsepower: '1020 HP', mileage: '396 miles', acceleration: '1.99 s',
      topSpeed: '200 mph',
      description: 'The quickest accelerating production sedan.',
      features: _premium, imageAsset: 'assets/cars/tesla_model_s.png',
    ),
    Car(
      id: 'porsche_gt3', name: 'Porsche 911 GT3 RS', brand: 'Porsche',
      price: 35000000, category: 'Sports', seats: 2, colorIndex: 4,
      rating: 4.9, reviews: 64, engine: '4.0L Flat-6', horsepower: '518 HP',
      mileage: '7 km/l', acceleration: '3.0 s', topSpeed: '184 mph',
      description: 'Race-bred 911 built for the circuit.',
      features: _premium, imageAsset: 'assets/cars/porsche_911.png',
    ),
    Car(
      id: 'lambo_huracan', name: 'Lamborghini Huracán Tecnica',
      brand: 'Lamborghini', price: 45000000, category: 'Sports', seats: 2,
      colorIndex: 3, rating: 4.9, reviews: 58, engine: '5.2L V10',
      horsepower: '631 HP', mileage: '6 km/l', acceleration: '2.9 s',
      topSpeed: '202 mph',
      description: 'Naturally aspirated V10 supercar.',
      features: _premium, imageAsset: 'assets/cars/lamborghini_huracan.png',
    ),
    Car(
      id: 'amg_gt', name: 'Mercedes-AMG GT 63 S', brand: 'Mercedes-Benz',
      price: 28000000, category: 'Sports', fuel: 'Hybrid', seats: 4,
      colorIndex: 0, rating: 4.8, reviews: 72, engine: '4.0L V8 Hybrid',
      horsepower: '831 HP', mileage: '8 km/l', acceleration: '2.9 s',
      topSpeed: '196 mph',
      description: 'Four-door hybrid performance coupe.',
      features: _premium, imageAsset: 'assets/cars/amg_gt.png',
    ),
    Car(
      id: 'ferrari_roma', name: 'Ferrari Roma Spider', brand: 'Ferrari',
      price: 43000000, category: 'Sports', seats: 2, colorIndex: 3,
      rating: 4.9, reviews: 41, engine: '3.9L Twin-Turbo V8',
      horsepower: '612 HP', mileage: '7 km/l', acceleration: '3.4 s',
      topSpeed: '199 mph',
      description: 'Open-top grand tourer with timeless styling.',
      features: _premium, imageAsset: 'assets/cars/ferrari_roma.png',
    ),
    Car(
      id: 'aston_vantage', name: 'Aston Martin Vantage F1 Edition',
      brand: 'Aston Martin', price: 30000000, category: 'Sports', seats: 2,
      colorIndex: 4, rating: 4.8, reviews: 37, engine: '4.0L Twin-Turbo V8',
      horsepower: '528 HP', mileage: '8 km/l', acceleration: '3.5 s',
      topSpeed: '195 mph',
      description: 'F1-inspired Vantage with a motorsport edge.',
      features: _premium, imageAsset: 'assets/cars/aston_vantage.png',
    ),
    Car(
      id: 'mclaren_artura', name: 'McLaren Artura', brand: 'McLaren',
      price: 55000000, category: 'Sports', fuel: 'Hybrid', seats: 2,
      colorIndex: 3, rating: 4.9, reviews: 29, engine: '3.0L V6 Hybrid',
      horsepower: '671 HP', mileage: '9 km/l', acceleration: '3.0 s',
      topSpeed: '205 mph',
      description: 'High-performance plug-in hybrid supercar.',
      features: _premium, imageAsset: 'assets/cars/mclaren_artura.png',
    ),
  ];
}

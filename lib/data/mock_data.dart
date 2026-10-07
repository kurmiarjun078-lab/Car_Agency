import 'package:flutter/material.dart';
import 'models.dart';

/// All mock content. Replace with your Firestore / API calls later;
/// the screens only depend on the models in models.dart.
class MockData {
  MockData._();

  // ---------------------------------------------------------------- Home
  static const List<CategoryItem> categories = [
    CategoryItem('SUV', Icons.airport_shuttle_outlined),
    CategoryItem('Sedan', Icons.directions_car_outlined),
    CategoryItem('Luxury', Icons.diamond_outlined),
    CategoryItem('Sports', Icons.speed_outlined),
    CategoryItem('Electric', Icons.electric_car_outlined),
  ];

  /// name -> logo asset (assets/brands/)
  static const Map<String, String> popularBrands = {
    'BMW': 'assets/brands/bmw.png',
    'Audi': 'assets/brands/audi.png',
    'Mercedes-Benz': 'assets/brands/mercedes_benz.png',
    'Toyota': 'assets/brands/toyota.png',
    'Honda': 'assets/brands/honda.png',
    'Nissan': 'assets/brands/nissan.png',
  };

  static const Car bmwM4 = Car(
    id: 'bmw_m4',
    name: 'BMW M4 Coupe',
    brand: 'BMW',
    price: 7500000,
    rating: 4.8,
    imageAsset: 'assets/cars/bmw_m4.png',
  );

  static const List<Car> featuredCars = [
    bmwM4,
    Car(
      id: 'audi_a8',
      name: 'Audi A8',
      brand: 'Audi',
      price: 6600000,
      rating: 4.9,
      imageAsset: 'assets/cars/audi_a8.png',
    ),
    Car(
      id: 'tesla_y',
      name: 'Tesla Model Y',
      brand: 'Tesla',
      price: 8000000,
      fuel: 'Electric',
      rating: 4.9,
      imageAsset: 'assets/cars/tesla_model_y.png',
    ),
  ];

  // -------------------------------------------------------------- Browse
  static const List<Car> browseCars = [
    Car(id: 'audi_a8', name: 'Audi A8', brand: 'Audi', price: 6600000,
        imageAsset: 'assets/cars/audi_a8.png'),
    Car(id: 'merc_c', name: 'Mercedes C-Class', brand: 'Mercedes-Benz',
        price: 6600000, imageAsset: 'assets/cars/mercedes_c_class.png'),
    Car(id: 'bmw_x5', name: 'BMW X5', brand: 'BMW', price: 6600000,
        fuel: 'Diesel', imageAsset: 'assets/cars/bmw_x5.png'),
    Car(id: 'tesla_y', name: 'Tesla Model Y', brand: 'Tesla', price: 8000000,
        fuel: 'Electric', imageAsset: 'assets/cars/tesla_model_y.png'),
    Car(id: 'audi_a5', name: 'Audi A5', brand: 'Audi', price: 6500000,
        imageAsset: 'assets/cars/audi_a5.png'),
    Car(id: 'bmw_m4', name: 'BMW M4 Coupe', brand: 'BMW', price: 7500000,
        rating: 4.8, imageAsset: 'assets/cars/bmw_m4.png'),
  ];

  // ------------------------------------------------------------ Listings
  static const List<Car> listingCars = [
    Car(id: 'porsche_gt3', name: 'Porsche 911 GT3 RS', brand: 'Porsche',
        price: 223800, currency: '\$', imageAsset: 'assets/cars/porsche_911.png'),
    Car(id: 'lambo_huracan', name: 'Lamborghini Huracán Tecnica',
        brand: 'Lamborghini', price: 239000, currency: '\$',
        imageAsset: 'assets/cars/lamborghini_huracan.png'),
    Car(id: 'amg_gt', name: 'Mercedes-AMG GT 63 S', brand: 'Mercedes-Benz',
        price: 161900, currency: '\$', fuel: 'Hybrid',
        imageAsset: 'assets/cars/amg_gt.png'),
    Car(id: 'ferrari_roma', name: 'Ferrari Roma Spider', brand: 'Ferrari',
        price: 247310, currency: '\$', imageAsset: 'assets/cars/ferrari_roma.png'),
    Car(id: 'aston_vantage', name: 'Aston Martin Vantage F1 Edition',
        brand: 'Aston Martin', price: 171000, currency: '\$',
        imageAsset: 'assets/cars/aston_vantage.png'),
    Car(id: 'mclaren_artura', name: 'McLaren Artura', brand: 'McLaren',
        price: 233000, currency: '\$', fuel: 'Hybrid',
        imageAsset: 'assets/cars/mclaren_artura.png'),
  ];

  // ------------------------------------------------------------ Wishlist
  static const List<Car> wishlistSeed = [
    bmwM4,
    Car(id: 'audi_a5', name: 'Audi A5', brand: 'Audi', price: 6500000,
        imageAsset: 'assets/cars/audi_a5.png'),
    Car(id: 'merc_c_wish', name: 'Mercedes C-Class', brand: 'Mercedes-Benz',
        price: 11200000, imageAsset: 'assets/cars/mercedes_c_class_black.png'),
  ];

  // ----------------------------------------------------- Car details demo
  static const Car teslaPlaid = Car(
    id: 'tesla_plaid',
    name: 'Tesla Model S Plaid',
    brand: 'Tesla',
    price: 89990,
    currency: '\$',
    fuel: 'Electric',
    imageAsset: 'assets/cars/tesla_model_s.png',
  );

  // ------------------------------------------------------------- Filters
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

  // ------------------------------------------------------------- Service
  static const List<ServiceItem> services = [
    ServiceItem(Icons.build_outlined, 'Oil Change', 2500),
    ServiceItem(Icons.tire_repair_outlined, 'Wheel Alignment', 1800),
    ServiceItem(Icons.settings_outlined, 'Engine Checkup', 3500),
    ServiceItem(Icons.battery_charging_full_outlined, 'Battery Check', 1500),
  ];
  static const List<String> dealerTimes = [
    '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '02:00 PM', '04:00 PM',
  ];

  // --------------------------------------------------------------- Admin
  static const List<Customer> customers = [
    Customer('Bishal Thapa', '+977 9801120000', 12,
        avatarAsset: 'assets/avatars/customer1.png'),
    Customer('Sagar Acharya', '+977 98111111111', 8,
        avatarAsset: 'assets/avatars/customer2.png'),
    Customer('Alex Shrestha', '+977 9822222222', 5,
        avatarAsset: 'assets/avatars/customer3.png'),
    Customer('Rohan Karki', '+977 9833333333', 7,
        avatarAsset: 'assets/avatars/customer4.png'),
  ];

  static const List<OrderItem> recentOrders = [
    OrderItem('BMW M4 Coupe', 7500000, OrderStatus.completed,
        imageAsset: 'assets/cars/bmw_m4.png'),
    OrderItem('Audi A6', 6500000, OrderStatus.pending,
        imageAsset: 'assets/cars/audi_a6.png'),
    OrderItem('Tesla Model Y', 5500000, OrderStatus.delivered,
        imageAsset: 'assets/cars/tesla_model_y.png'),
  ];

  /// Normalised (0..1) revenue points Jan..Jun, read off the Figma chart.
  static const List<double> revenueCurve = [0.09, 0.37, 0.29, 0.63, 0.58, 1.0];
  static const List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
}

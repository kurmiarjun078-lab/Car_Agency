import 'package:flutter_test/flutter_test.dart';
import 'package:drivehub/core/formatters.dart';
import 'package:drivehub/data/app_data.dart';
import 'package:drivehub/data/car_filter.dart';
import 'package:drivehub/data/models.dart';

void main() {
  test('prices use Indian grouping', () {
    expect(formatPrice(7500000), '₹75,00,000');
    expect(formatPrice(11200000), '₹1,12,00,000');
    expect(formatPrice(2500), '₹2,500');
    expect(formatCompactPrice(24500000), '₹2.45 Cr');
  });

  test('sample cars are valid and have unique ids', () {
    final ids = AppData.seedCars.map((c) => c.id).toSet();
    expect(ids.length, AppData.seedCars.length);
    expect(AppData.seedCars.every((c) => c.price > 0 && c.name.isNotEmpty),
        isTrue);
  });

  test('car survives a toMap / fromMap round trip', () {
    final car = AppData.seedCars.first;
    final copy = Car.fromMap(car.id, car.toMap());
    expect(copy.name, car.name);
    expect(copy.price, car.price);
    expect(copy.features, car.features);
    expect(copy.category, car.category);
  });

  test('user profile reads the saved photo', () {
    final user = AppUser.fromMap('user-1', {
      'name': 'Asha',
      'email': 'asha@example.com',
      'phone': '1234567890',
      'photo': 'encoded-photo',
      'role': 'user',
    });

    expect(user.photo, 'encoded-photo');
    expect(user.name, 'Asha');
    expect(user.phone, '1234567890');
  });

  test('filters and sorting work', () {
    const cars = AppData.seedCars;
    final electric =
        applyCarFilters(cars, filter: const CarFilter(fuel: 'Electric'));
    expect(electric.isNotEmpty, isTrue);
    expect(electric.every((c) => c.fuel == 'Electric'), isTrue);

    final cheap =
        applyCarFilters(cars, filter: const CarFilter(maxPrice: 7000000));
    expect(cheap.every((c) => c.price <= 7000000), isTrue);

    final sorted = applyCarFilters(cars, sort: SortOption.priceLow);
    expect(sorted.first.price <= sorted.last.price, isTrue);

    final search = applyCarFilters(cars, query: 'bmw');
    expect(search.every((c) => c.brand == 'BMW'), isTrue);
  });
}

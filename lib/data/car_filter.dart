import 'models.dart';

enum SortOption { none, priceLow, priceHigh, rating }

/// Result of the Filter sheet. A null field means "not filtered".
class CarFilter {
  const CarFilter({
    this.minPrice,
    this.maxPrice,
    this.brand,
    this.fuel,
    this.transmission,
    this.seats,
    this.colorIndex,
  });

  final int? minPrice;
  final int? maxPrice;
  final String? brand;
  final String? fuel;
  final String? transmission;
  final String? seats;
  final int? colorIndex; // mock cars have no colour data, so it isn't applied

  static const CarFilter empty = CarFilter();

  bool get isEmpty =>
      minPrice == null &&
      maxPrice == null &&
      brand == null &&
      fuel == null &&
      transmission == null &&
      seats == null &&
      colorIndex == null;

  bool matches(Car car, {bool usePrice = true}) {
    if (usePrice) {
      if (minPrice != null && car.price < minPrice!) return false;
      if (maxPrice != null && car.price > maxPrice!) return false;
    }
    if (brand != null && car.brand != brand) return false;
    if (fuel != null && car.fuel != fuel) return false;
    if (transmission != null && car.transmission != transmission) return false;
    return true;
  }
}

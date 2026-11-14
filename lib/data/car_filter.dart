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
    this.category,
  });

  final int? minPrice;
  final int? maxPrice;
  final String? brand;
  final String? fuel;
  final String? transmission;
  final String? seats;
  final int? colorIndex;
  final String? category;

  static const CarFilter empty = CarFilter();

  bool get isEmpty =>
      minPrice == null &&
      maxPrice == null &&
      brand == null &&
      fuel == null &&
      transmission == null &&
      seats == null &&
      colorIndex == null &&
      category == null;

  bool matches(Car car) {
    if (minPrice != null && car.price < minPrice!) return false;
    if (maxPrice != null && car.price > maxPrice!) return false;
    if (brand != null && car.brand != brand) return false;
    if (fuel != null && car.fuel != fuel) return false;
    if (transmission != null && car.transmission != transmission) return false;
    if (seats != null && car.seats.toString() != seats) return false;
    if (colorIndex != null && car.colorIndex != colorIndex) return false;
    if (category != null && car.category != category) return false;
    return true;
  }
}

/// Search text + filter + sort applied to a car list.
List<Car> applyCarFilters(
  List<Car> cars, {
  String query = '',
  CarFilter filter = CarFilter.empty,
  SortOption sort = SortOption.none,
}) {
  final q = query.trim().toLowerCase();
  final list = cars
      .where((c) =>
          (q.isEmpty || '${c.name} ${c.brand} ${c.category}'.toLowerCase().contains(q)) &&
          filter.matches(c))
      .toList();
  switch (sort) {
    case SortOption.priceLow:
      list.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceHigh:
      list.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.rating:
      list.sort((a, b) => b.rating.compareTo(a.rating));
    case SortOption.none:
      break;
  }
  return list;
}

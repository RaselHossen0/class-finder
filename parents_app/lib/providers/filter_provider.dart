import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider =
    StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

class FilterState {
  final double priceRange;
  final double priceRangeMax; // Added for max range
  final double distanceRange;
  final String location;
  final String category;

  FilterState({
    this.priceRange = 0,
    this.priceRangeMax = 5000, // Default max price range
    this.distanceRange = 3000,
    this.location = '',
    this.category = '',
  });

  FilterState copyWith({
    double? priceRange,
    double? priceRangeMax,
    double? distanceRange,
    String? location,
    String? category,
  }) {
    return FilterState(
      priceRange: priceRange ?? this.priceRange,
      priceRangeMax: priceRangeMax ?? this.priceRangeMax,
      distanceRange: distanceRange ?? this.distanceRange,
      location: location ?? this.location,
      category: category ?? this.category,
    );
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void updatePriceRange(double start, double end) {
    state = state.copyWith(priceRange: start, priceRangeMax: end);
  }

  void updateDistanceRange(double value) {
    state = state.copyWith(distanceRange: value);
  }

  void updateLocation(String value) {
    state = state.copyWith(location: value);
  }

  void updateCategory(String value) {
    state = state.copyWith(category: value);
  }
}

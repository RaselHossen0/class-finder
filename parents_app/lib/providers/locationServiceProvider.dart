import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  LocationNotifier() : super(const AsyncLoading());

  Future<void> fetchLocation() async {
    try {
      // Check permissions and get the current position
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition();
      print(position);

      // Reverse geocoding to get the city name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract city name
      String city = placemarks.first.locality ?? 'Unknown City';

      // Update state with latitude, longitude, and city name
      state = AsyncData({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'city': city,
        'address': placemarks.first.name,
      });
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      // Extract city name
      String city = placemarks.first.locality ?? 'Unknown City';

      // Update state with the custom latitude, longitude, and city name
      state = AsyncData({
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'address': placemarks.first.name,
      });
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

// Provider for LocationNotifier
final locationNotifierProvider =
    StateNotifierProvider<LocationNotifier, AsyncValue<Map<String, dynamic>>>(
  (ref) => LocationNotifier(),
);

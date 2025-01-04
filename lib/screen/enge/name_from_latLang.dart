import 'package:geocoding/geocoding.dart';

Future<String> getPlaceName(double latitude, double longitude) async {
  try {
    // Get the placemark for the given latitude and longitude
    print(latitude);
    print(longitude);
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    // Check if placemarks are available
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      // You can return the specific field you want here, like locality, country, or full address.
      // For simplicity, we'll return the locality (city or area name).
      print(placemark.name);
      return placemark.locality ?? placemark.name ?? 'Unknown location';
    } else {
      return 'No place found';
    }
  } catch (e) {
    print("                      putki       mar              ");
    return 'Error: $e';
  }
}

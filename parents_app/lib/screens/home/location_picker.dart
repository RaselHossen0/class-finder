import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../providers/locationServiceProvider.dart';

class GoogleMapLocationPicker extends ConsumerStatefulWidget {
  const GoogleMapLocationPicker({Key? key}) : super(key: key);

  @override
  _GoogleMapLocationPickerState createState() =>
      _GoogleMapLocationPickerState();
}

class _GoogleMapLocationPickerState
    extends ConsumerState<GoogleMapLocationPicker> {
  LatLng? selectedLocation;
  late GoogleMapController _mapController;
  late LatLng currentPos;
  bool isLoading = true; // To track the loading state

  getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPos = LatLng(position.latitude, position.longitude);
        isLoading = false; // Stop loading once the position is fetched
      });
      _mapController.animateCamera(
        CameraUpdate.newLatLng(currentPos),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
      // Handle the error (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching location: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize currentPos with a default value until the actual location is fetched.
    currentPos = LatLng(23.8103, 90.4125); // Default location: Dhaka
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Select Your Location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Show a loading spinner if the location is still being fetched
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                    // After the map is created, update the camera position if currentPos is set.
                    if (currentPos != null) {
                      _mapController.animateCamera(
                        CameraUpdate.newLatLng(currentPos),
                      );
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target:
                        currentPos, // Default location (or last known location)
                    zoom: 12,
                  ),
                  onTap: (LatLng position) {
                    setState(() {
                      selectedLocation = position;
                    });
                  },
                  markers: selectedLocation != null
                      ? {
                          Marker(
                            markerId: MarkerId('selected-location'),
                            position: selectedLocation!,
                          ),
                        }
                      : {},
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: selectedLocation != null
                ? () async {
                    final lat = selectedLocation!.latitude;
                    final lng = selectedLocation!.longitude;

                    // Update the provider with the new location
                    ref
                        .read(locationNotifierProvider.notifier)
                        .updateLocation(lat, lng);

                    Navigator.pop(context);
                  }
                : null,
            child: Text('Confirm Location'),
          ),
        ),
      ],
    );
  }
}

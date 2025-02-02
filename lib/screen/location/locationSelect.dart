import 'package:class_rasel/Global.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> DisplayLocationSelector(
    BuildContext context,
    LatLng initialLt,
    TextEditingController searchLocation,
    bool isLoading,
    LatLng setLatLang) async {
  GoogleMapController? mapController;
  Set<Marker> markers = {
    Marker(
      markerId: MarkerId('initial_marker'),
      position: initialLt,
      infoWindow: InfoWindow(title: 'Selected Location'),
    ),
  };

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location Search Field
                  TextFormField(
                    controller: searchLocation,
                    decoration: InputDecoration(
                      labelText: 'Search Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          if (searchLocation.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please enter a location.')),
                            );
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            List<Location> locations =
                                await locationFromAddress(searchLocation.text);
                            if (locations.isNotEmpty) {
                              Location location = locations.first;
                              LatLng newLatLng = LatLng(
                                location.latitude,
                                location.longitude,
                              );
                              setLatLang = newLatLng;

                              // Move camera to searched location
                              mapController?.animateCamera(
                                CameraUpdate.newLatLng(newLatLng),
                              );

                              // Update marker
                              setState(() {
                                markers = {
                                  Marker(
                                    markerId: MarkerId('searched_marker'),
                                    position: newLatLng,
                                    infoWindow: InfoWindow(
                                      title: searchLocation.text,
                                    ),
                                  ),
                                };
                              });
                            } else {
                              throw Exception('No locations found.');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not find location.'),
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Google Map Display
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: initialLt,
                        zoom: 15,
                      ),
                      markers: markers,
                      onTap: (LatLng tappedLocation) async {
                        setLatLang = tappedLocation;

                        // Fetch address from coordinates
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            tappedLocation.latitude,
                            tappedLocation.longitude,
                          );

                          if (placemarks.isNotEmpty) {
                            Placemark place = placemarks.first;
                            String address =
                                '${place.street}, ${place.locality}, ${place.country}';
                            searchLocation.text = address; // Update controller
                          }

                          // Update marker position
                          setState(() {
                            markers = {
                              Marker(
                                markerId: MarkerId('tapped_marker'),
                                position: tappedLocation,
                                infoWindow:
                                    InfoWindow(title: 'Selected Location'),
                              ),
                            };
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error fetching address.')),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Select Location Button
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              // Simulate API call
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.pop(context, setLatLang);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error selecting location.'),
                                ),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: cPrimaryColor,
                          )
                        : Text(
                            'Select Location',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}

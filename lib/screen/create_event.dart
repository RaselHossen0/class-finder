
import 'dart:io';

import 'package:class_rasel/create_event_service.dart';
import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../componants/app_bar.dart';

LatLng gett=LatLng(23.8041, 90.4152);

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _dateController = TextEditingController();
  final _searchLocation=TextEditingController();
  LatLng markerLocation = LatLng(23.8041, 90.4152);
  final cont creatEv = Get.find();
  bool locationNodal = false;
  final List<File> _selectedImages = []; // List to hold selected images
  bool isLoading=false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBar(title: "Third Page For Owner"),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Class Name', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  TextFormField(
                    controller: _title,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Description', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  TextFormField(
                    controller: _description,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Select Date', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Locations', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  TextFormField(
                    controller: _searchLocation,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.location_on,
                            color: Colors.orange), // Location icon
                        onPressed: () {
                          // Perform action when button is pressed

                          displayLocationSelector(context, gett,
                              _searchLocation);
                        }
                      ),
                      hintText: 'Enter location',
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Select Photos', style: TextStyle(fontSize: 14)),
                      Spacer(),
                      ElevatedButton(
                        onPressed: _pickImages,
                        child: Text('Pick Images'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Display selected images
                  _selectedImages.isNotEmpty
                      ? SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.file(
                            _selectedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  )
                      : Center(
                    child: Text(
                      'No images selected',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null // Disable button if loading
                      : () async {
                    setState(() {
                      isLoading = true;
                    });

                    print("                      999999999           ");

                    EasyLoading.show(
                        status: 'Logging in...'); // Show loading

                    try {
                      print(" get             token");
                      print(creatEv.token);
                      print("                 9999999999            ");

                      String latLngString = '${gett.latitude.toString()},${gett.longitude.toString()}';


                      print("                 9999999999            ");
                      print(creatEv.token);
                      var result = await createEvent(_title.text, _dateController.text, _description.text, creatEv.classId!, latLngString, _selectedImages,creatEv.token);

                      if (result != null && result.statusCode == 201) {
                        Get.offNamed("/Enge/:2");
                      } else {
                        // Handle unexpected null response or other status codes
                        EasyLoading.showError('Unexpected error occurred. Please try again.');
                      }


                    } catch (e) {
                      // Handle network or API errors
                      print("Error: $e");

                      EasyLoading.showError(
                          'An error occurred. Please try again.');
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                      EasyLoading
                          .dismiss(); // Hide loading after response
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 15, 98, 233),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Sign Up as Class Owner',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<LatLng?> displayLocationSelector(
    BuildContext context,
    LatLng initialLatLng,
    TextEditingController searchLocationController,
    ) async {
  GoogleMapController? mapController;
  LatLng currentLatLng = initialLatLng;

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId('initial_marker'),
      position: initialLatLng,
      infoWindow: InfoWindow(title: 'Selected Location'),
    ),
  };

  // Initialize the searchLocationController with the name of the initial location
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      initialLatLng.latitude,
      initialLatLng.longitude,
    );
    if (placemarks.isNotEmpty) {
      searchLocationController.text =
      "${placemarks.first.name}, ${placemarks.first.locality}";
    }
  } catch (e) {
    searchLocationController.text = "Unknown Location";
  }

  return await showModalBottomSheet<LatLng>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: searchLocationController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Search location',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        String query = searchLocationController.text.trim();
                        if (query.isNotEmpty) {
                          try {
                            List<Location> locations =
                            await locationFromAddress(query);
                            if (locations.isNotEmpty) {
                              Location location = locations.first;
                              LatLng newLatLng = LatLng(
                                location.latitude,
                                location.longitude,
                              );

                              setState(() {
                                currentLatLng = newLatLng;
                                markers = {
                                  Marker(
                                    markerId: MarkerId('searched_marker'),
                                    position: newLatLng,
                                    infoWindow: InfoWindow(title: query),
                                  ),
                                };
                              });

                              mapController?.animateCamera(
                                CameraUpdate.newLatLng(newLatLng),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Location not found!')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: initialLatLng,
                      zoom: 15,
                    ),
                    markers: markers,
                    onTap: (LatLng tappedPosition) async {
                      setState(() {
                        currentLatLng = tappedPosition;
                        markers = {
                          Marker(
                            markerId: MarkerId('tapped_marker'),
                            position: tappedPosition,
                            infoWindow: InfoWindow(title: 'Selected Location'),
                          ),
                        };
                      });

                      // Reverse geocode to get the address of the tapped position
                      try {
                        List<Placemark> placemarks =
                        await placemarkFromCoordinates(
                          tappedPosition.latitude,
                          tappedPosition.longitude,
                        );
                        if (placemarks.isNotEmpty) {
                          setState(() {
                            searchLocationController.text =
                            "${placemarks.first.name}, ${placemarks.first.locality}";
                          });
                        }
                      } catch (e) {
                        searchLocationController.text = "Unknown Location";
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, currentLatLng);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Confirm Location'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

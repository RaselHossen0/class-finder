
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

LatLng gett=LatLng(0, 0);

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
                          DisplayLocationSelector(context, markerLocation,
                              _searchLocation, locationNodal, gett);
                        },
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

Future DisplayLocationSelector(BuildContext context, LatLng initialLt,
    TextEditingController searchLocation, bool showModal, LatLng setLatLang) {
  // Variable to hold the GoogleMapController
  GoogleMapController? mapController;

  // Marker to dynamically update
  Set<Marker> marker = {
    Marker(
      markerId: MarkerId('initial_marker'),
      position: initialLt,
      infoWindow: InfoWindow(title: 'Initial Location'),
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
        return SizedBox(
          height: 800,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Search Location Field
                TextFormField(
                  controller: searchLocation,
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
                    suffixIcon: IconButton(
                      onPressed: () async {
                        try {
                          // Fetch location coordinates
                          List<Location> locations = [];

                          try {
                            locations =
                            await locationFromAddress(searchLocation.text);
                          } catch (e) {
                            print("              1111111111              ");
                            print(e);
                          }
                          if (locations.isNotEmpty) {
                            Location location = locations.first;
                            LatLng newLatLng =
                            LatLng(location.latitude, location.longitude);
                            gett = newLatLng;
                            print(setLatLang);

                            // Update the camera position
                            if (mapController != null) {
                              mapController!.animateCamera(
                                  CameraUpdate.newLatLng(newLatLng));
                            }

                            // Update marker on the map
                            setState(() {
                              marker = {
                                Marker(
                                  markerId: MarkerId('searched_marker'),
                                  position: newLatLng,
                                  infoWindow:
                                  InfoWindow(title: searchLocation.text),
                                ),
                              };
                            });
                          }
                        } catch (e) {
                          // Handle errors (e.g., invalid address)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Location not found!')),
                          );
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Google Map
                SizedBox(
                  height: 600,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController cnt) {
                      // Save the controller directly
                      mapController = cnt;
                    },
                    initialCameraPosition: CameraPosition(
                      target: initialLt,
                      zoom: 17,
                    ),
                    markers: marker,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: showModal
                        ? null // Disable button if loading
                        : () async {
                      setState(() {
                        showModal = true;
                      });

                      EasyLoading.show(
                          status: 'Logging in...'); // Show loading

                      try {
                        await Future.delayed(
                            Duration(seconds: 2)); // Simulate API call

                        Navigator.pop(context);
                      } catch (e) {
                        // Handle network or API errors
                        print("Error: $e");

                        EasyLoading.showError(
                            'An error occurred. Please try again.');
                      } finally {
                        setState(() {
                          showModal = false;
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
                    child: showModal
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
        );
      },
    ),
  );
}


import 'package:class_rasel/componants/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../every class/get_controller.dart';
import 'compleate_signup.dart';

LatLng gett = LatLng(0, 0);

class ThPage extends StatefulWidget {
  const ThPage({super.key});

  @override
  State<ThPage> createState() => _ThPageState();
}

class _ThPageState extends State<ThPage> {
  final _className = TextEditingController();
  final cont signUp = Get.find();
  final _description = TextEditingController();
  LatLng markerLocation = LatLng(23.8041, 90.4152);
  final _searchLocation = TextEditingController();
  bool locationNodal = false;
  bool isLoading = false;
  //LatLng gett=LatLng(0, 0);
  List<dynamic> options = [];
  List<String> optionsName = [];
  int changeId = 0;
  Map<String, int> aluu = Map();
  String? _selectOption;
  bool kajShesh = false;
  void initState() {
    super.initState();
    _initializeData();
    //optionToString();
  }

// Create an async helper function
  Future<void> _initializeData() async {
    print("Fetching categories...");
    try {
      var result = await fetchCategories();
      setState(() {
        options = result.data;
        optionToString();
        _selectOption = optionsName[0];
        kajShesh = true;
      });
      print("Categories fetched successfully: $options");
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> optionToString() async {
    try {
      for (int i = 0; i < options.length; i++) {
        optionsName.add(options[i]['name']);

        aluu?[options[i]['name']] = options[i]['id'];
      }

      print(optionsName);
      print(aluu["String"]);
    } catch (e) {
      print("11111                    11111111          ");
      print(e);
      print(optionsName);
    }
  }

  ChangeIdnunu(String putki) {
    changeId = aluu[putki]!;
  }

  @override
  Widget build(BuildContext context) {
    if (kajShesh) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  appBar(title: "Third Page For Owner"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Class Name', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  TextFormField(
                    controller: _className,
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
                    children: const [
                      Text('Select an Option', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownMenu<String>(
                      width: double.infinity,
                      initialSelection: optionsName[0],
                      dropdownMenuEntries: optionsName.map((String option) {
                        return DropdownMenuEntry(
                          value: option,
                          label: option,
                        );
                      }).toList(),
                      onSelected: (String? newValue) {
                        setState(() {
                          _selectOption = newValue;
                          ChangeIdnunu(_selectOption!);
                        });
                      },
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Descriptions', style: TextStyle(fontSize: 14)),
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

                          EasyLoading.show(
                              status: 'Logging in...'); // Show loading

                          try {
                            signUp.user.className = _className.text;
                            signUp.user.category = changeId;
                            signUp.user.locationName = _searchLocation.text;
                            //print("11111             11111       asda");
                            print(gett);

                            List<double> aluKhor = [
                              gett.latitude,
                              gett.longitude
                            ];
                            signUp.user.latLang = aluKhor;
                            print(aluKhor);
                            signUp.user.description = _description.text;
                            //print("11111             11111       asda");

                            // print(signUp.user.photo);
                            // print(signUp.user.aadharCardFile);
                            //
                            // print(signUp.user.panCardFile);

                            var result = completeSignup(signUp.user);
                            print(result);
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
        )),
      );
    } else {
      return CircularProgressIndicator();
    }
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

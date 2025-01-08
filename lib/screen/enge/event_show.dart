import 'package:class_rasel/screen/enge/see_who_show_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../every class/get_controller.dart';
import 'event_service.dart';


LatLng gett=LatLng(0, 0);

class EventShow extends StatefulWidget {
  const EventShow({super.key});

  @override
  State<EventShow> createState() => _EventShowState();
}

class _EventShowState extends State<EventShow> {
  late Map<String, dynamic> eventData;
  bool isLoading = true; // Loading state to show the spinner
  final cont eventShow = Get.find();
  String nameLocation="";

  @override
  void initState() {
    super.initState();
    initialization();
  }
  Future<String> getPlaceNameFromLatLng(String latLngString) async {
    try {
      // Parse the input string to extract latitude and longitude
      final parts = latLngString.split(',');
      if (parts.length != 2) {
        throw FormatException('Invalid LatLng format. Use "latitude, longitude".');
      }

      final double latitude = double.parse(parts[0].trim());
      final double longitude = double.parse(parts[1].trim());

      // Perform reverse geocoding to get place details
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        // Build a readable name using the placemark information
        final Placemark place = placemarks.first;
        return "${place.name}, ${place.locality}, ${place.country}";
      } else {
        return "Unknown Location";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
  Future<void> initialization() async {
    try {
      var result = await fetchEventById(eventShow.curretEventId!, eventShow.token);

      if (result.statusCode == 200) {
        setState(() {
          eventData = result.data;

          isLoading = false;

        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load event data.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showEditBottomSheet() {
    final titleController = TextEditingController(text: eventData["title"]);
    final descriptionController = TextEditingController(text: eventData["description"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Event",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null // Disable button if loading
                        : () async {
                      setState(() {
                        isLoading = true;
                      });

                      EasyLoading.show(
                          status: 'Logging in...'); // Show loading

                      try {

                        eventData["title"] = titleController.text;
                        eventData["description"] = descriptionController.text;

                        var result =await updateEventById(eventShow.token, eventShow.curretEventId!, eventData);

                        print(result.statusCode);
                        if(result.statusCode==200){
                          EasyLoading.showSuccess(result.data["message"]);
                        }

                      } catch (e) {
                        // Handle network or API errors
                        print("                                  ttttttttttttt                    ");
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
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                    onPressed: isLoading
                        ? null // Disable button if loading
                        : () async {
                      setState(() {
                        isLoading = true;
                      });

                      EasyLoading.show(
                          status: 'Logging in...'); // Show loading

                      try {

                        String alu ="${currentLatLng.latitude},${currentLatLng.longitude}";
                         eventData["location"]=alu;

                        var result =await updateEventById(eventShow.token, eventShow.curretEventId!, eventData);

                        print(result.statusCode);
                        if(result.statusCode==200){
                          EasyLoading.showSuccess(result.data["message"]);
                        }

                      } catch (e) {
                        // Handle network or API errors
                        print("                                  ttttttttttttt                    ");
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Event Details",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            _buildActionButton(
                              icon: Icons.edit,
                              color: Colors.blue,
                              onTap: _showEditBottomSheet,
                              tooltip: "Edit Event",
                            ),
                            SizedBox(width: 8),
                            _buildActionButton(
                              icon: Icons.location_on,
                              color: Colors.red,
                              onTap: () {
                                TextEditingController locationController = TextEditingController();
                                displayLocationSelector(
                                  context,
                                  LatLng(37.7749, -122.4194),
                                  locationController,
                                );
                              },
                              tooltip: "Change Location",
                            ),
                            SizedBox(width: 8),
                            _buildActionButton(
                              icon: Icons.calendar_today,
                              color: Colors.green,
                              onTap: () async {
                                String timestampString = eventData["date"];
                                DateTime initialDate = DateTime.parse(timestampString);
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors.green,
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  String selectedTimestamp = pickedDate.toUtc().toIso8601String();
                                  // Handle date update
                                }
                              },
                              tooltip: "Change Date",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection("Title", "title", Icons.title),
                    SizedBox(height: 16),
                    _buildInfoSection("Date", "date", Icons.access_time),
                    SizedBox(height: 16),
                    _buildInfoSection("Location", "location", Icons.location_on),
                    SizedBox(height: 16),
                    _buildInfoSection("Description", "description", Icons.description),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.people, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            "Event Participants",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: UserListPage(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

      ),
    );
  }
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String field, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              eventData[field] ?? "Not specified",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String fieldKey) {
    String displayValue = eventData[fieldKey] ?? '';

    // Format date if the field is "date"
    if (fieldKey == 'date') {
      try {
        DateTime parsedDate = DateTime.parse(displayValue);
        displayValue = DateFormat('d MMMM EEEE h:mm a').format(parsedDate);
      } catch (e) {
        displayValue = eventData[fieldKey];
      }
    }

    // Async function to get the place name from LatLng
    Future<String> getPlaceNameFromLatLng(String latLngString) async {
      try {
        // Parse the input string to extract latitude and longitude
        final parts = latLngString.split(',');
        if (parts.length != 2) {
          throw FormatException('Invalid LatLng format. Use "latitude, longitude".');
        }

        final double latitude = double.parse(parts[0].trim());
        final double longitude = double.parse(parts[1].trim());

        // Perform reverse geocoding to get place details
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

        if (placemarks.isNotEmpty) {
          // Build a readable name using the placemark information
          final Placemark place = placemarks.first;
          return "${place.name}, ${place.locality}, ${place.country}";
        } else {
          return "Unknown Location";
        }
      } catch (e) {
        return "Error: ${e.toString()}";
      }
    }

    if (fieldKey == 'location') {
      return FutureBuilder<String>(
        future: getPlaceNameFromLatLng(displayValue),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      snapshot.data ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              displayValue,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

}


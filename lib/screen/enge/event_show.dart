import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../every class/get_controller.dart';
import 'event_service.dart';

LatLng gett = LatLng(0, 0);

class EventShow extends StatefulWidget {
  const EventShow({super.key});

  @override
  State<EventShow> createState() => _EventShowState();
}

class _EventShowState extends State<EventShow> {
  late Map<String, dynamic> eventData;
  bool isLoading = true; // Loading state to show the spinner
  final cont eventShow = Get.find();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    try {
      var result =
          await fetchEventById(eventShow.curretEventId!, eventShow.token);
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
    final descriptionController =
        TextEditingController(text: eventData["description"]);

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
                              eventData["description"] =
                                  descriptionController.text;

                              var result = await updateEventById(
                                  eventShow.token,
                                  eventShow.curretEventId!,
                                  eventData);

                              print(result.statusCode);
                              if (result.statusCode == 200) {
                                EasyLoading.showSuccess(result.data["message"]);
                              }
                            } catch (e) {
                              // Handle network or API errors
                              print(
                                  "                                  ttttttttttttt                    ");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top title with buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Event Details",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _showEditBottomSheet,
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueAccent),
                              tooltip: "Edit",
                            ),
                            IconButton(
                              onPressed: () {
                                // Handle location button press
                              },
                              icon: const Icon(Icons.location_on,
                                  color: Colors.redAccent),
                              tooltip: "Location",
                            ),
                            IconButton(
                              onPressed: () {
                                // Handle calendar button press
                              },
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.green),
                              tooltip: "Calendar",
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildField("Title", "title"),
                    _buildField("Date", "date"),
                    _buildField("Location", "location"),
                    _buildField("Description", "description"),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

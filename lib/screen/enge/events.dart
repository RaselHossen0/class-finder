import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:class_rasel/screen/enge/event_card.dart';
import 'package:class_rasel/screen/enge/event_data.dart';
import 'package:class_rasel/screen/enge/event_service.dart';
import 'package:class_rasel/screen/enge/name_from_latLang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Global.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<EventData> data = [];
  final cont evCont = Get.find();

  @override
  void initState() {
    super.initState();
    initCard(); // Initialize event data
  }

  void initCard() async {
    EasyLoading.show(status: 'Loading...'); // Show loading
    try {
      var result = await fetchEvents(evCont.token);
      print(result.data);
      if (result.statusCode == 200) {
        for (var item in result.data["data"]) {
          print("                        putki before location fetch          ");

          // Extract latitude and longitude from "33,33"

          String locationStr = item["location"];

          print(item["location"]);

          // Split the location by the comma and trim spaces
          List<String> coordinates = locationStr.split(',').map((e) => e.trim()).toList();

          // Check if coordinates are valid
          if (coordinates.length < 2) {
            print("Invalid coordinates: $coordinates");
            continue; // Skip this item if coordinates are invalid
          }

          // Clean up and parse coordinates safely
          String latStr = coordinates[0];
          String langStr = coordinates[1];

          double lat = 0.0;
          double lang = 0.0;

          try {
            lat = double.parse(latStr);
            lang = double.parse(langStr);
          } catch (e) {
            print("Error parsing coordinates: $latStr, $langStr");
            continue; // Skip this item if parsing fails
          }

          // Round the values to two decimal places
          lat = double.parse(lat.toStringAsFixed(2));
          lang = double.parse(lang.toStringAsFixed(2));

         // print("                        Coordinates: lat=$lat, lang=$lang          ");

          // Fetch the place name using the lat and lang
          print(lat);
          String putki = await getPlaceName(lat, lang);
          //print("                        putki after location fetch: $putki");

          // Create EventData object
          EventData el = EventData(
            eventCaption: item["title"],
            eventDescription: item["description"],
            eventId: item["id"],
            eventImg: item["EventMedia"],
            date: item["date"],
            location: putki, // Set location as the place name
          );
          data.add(el);
        }
        setState(() {}); // Update UI after data fetch
      }
    } catch (e) {
      EasyLoading.showError('Failed to load events'); // Show error
      print("Error occurred: $e"); // Print any caught error
    } finally {
      EasyLoading.dismiss(); // Dismiss loading
    }
  }




  List<dynamic> alu = [
    {
      "id": 3,
      "url": "https://the7eagles.com/wp-content/uploads/2024/05/What-is-an-Image-URL-1536x864.webp",
      "type": "image/webp",
      "eventId": 1,
      "createdAt": "2024-12-27T08:57:42.000Z",
      "updatedAt": "2024-12-27T08:57:42.000Z"
    },
    {
      "id": 2,
      "url": "https://the7eagles.com/wp-content/uploads/2024/05/What-is-an-Image-URL-1536x864.webp",
      "type": "image/webp",
      "eventId": 1,
      "createdAt": "2024-12-27T08:57:42.000Z",
      "updatedAt": "2024-12-27T08:57:42.000Z"
    },
    {
      "id": 1,
      "url": "https://the7eagles.com/wp-content/uploads/2024/05/What-is-an-Image-URL-1536x864.webp",
      "type": "image/webp",
      "eventId": 1,
      "createdAt": "2024-12-27T08:57:42.000Z",
      "updatedAt": "2024-12-27T08:57:42.000Z"
    }
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Create Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/CreateEvent');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        add,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Display list of events using ListView.builder
            data.isEmpty
                ? const Center(child: Text("No events available"))
                : ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return EventCard(event: data[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

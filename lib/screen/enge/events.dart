import 'package:class_rasel/screen/enge/event_card.dart';
import 'package:class_rasel/screen/enge/event_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Global.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<dynamic> ev = [
    {
      "url": "https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2022/03/facebook_event_covers_cover.jpg?resize=1250,1120",
      "cap": "Event 1"
    },
    {
      "url": "https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2022/03/facebook_event_covers_cover.jpg?resize=1250,1120",
      "cap": "Event 2"
    },
    {
      "url": "https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2022/03/facebook_event_covers_cover.jpg?resize=1250,1120",
      "cap": "Event 3"
    },
  ];

  List<EventData> data = [];

  @override
  void initState() {
    super.initState();
    initCard(); // Initialize event data
  }

  void initCard() {
    for (int i = 0; i < ev.length; i++) {
      var event = EventData(
        eventCaption: ev[i]["cap"],
        eventId: "$i",
        eventImg: ev[i]["url"],
        date: "15 sep 2024",
        location: "Hatirjhil",
      );
      data.add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create Events",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      add,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Display list of events using ListView.builder
            ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return EventCard( event: data[index],);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for each event card

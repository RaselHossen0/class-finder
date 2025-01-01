import 'package:carousel_slider/carousel_slider.dart';
import 'package:class_finder/constants.dart';
import 'package:class_finder/models/event.dart';
import 'package:class_finder/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../providers/joinEventProvider.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  final Event event;

  EventDetailsScreen({required this.event});

  @override
  ConsumerState<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends ConsumerState<EventDetailsScreen> {
  LatLng? eventCoordinates;
  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoordinates();
  }

  Future<void> _fetchCoordinates() async {
    try {
      // Use Geocoding to get coordinates from the location string
      List<Location> locations =
          await locationFromAddress(widget.event.location);
      if (locations.isNotEmpty) {
        setState(() {
          eventCoordinates =
              LatLng(locations.first.latitude, locations.first.longitude);
          isMapLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isMapLoading = false;
      });
      print('Error fetching coordinates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailsProvider);

    final joinEventState = ref.watch(joinEventProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Event Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            if (widget.event.eventMedia.isNotEmpty)
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.3,
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    items: widget.event.eventMedia.map<Widget>((media) {
                      return Image.network(
                        frontEndUrl + "/" + media.url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      widget.event.title,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Event Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
                      const SizedBox(width: 10),
                      Text(
                        '${widget.event.date.day} ${DateFormat('MMM yyyy').format(widget.event.date)}',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: Colors.grey[600]),
                      const SizedBox(width: 10),
                      Text(
                        widget.event.location,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: Colors.grey[800],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Location Map
            if (isMapLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (eventCoordinates != null)
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: eventCoordinates!,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('eventLocation'),
                        position: eventCoordinates!,
                        infoWindow: InfoWindow(title: widget.event.title),
                      ),
                    },
                  ),
                ),
              )
            else
              Center(
                child: Text(
                  'Location not found',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            const SizedBox(height: 20),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // RSVP Logic
                        ref
                            .read(joinEventProvider.notifier)
                            .joinEvent(widget.event.id, user!.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: joinEventState.when(
                        data: (message) => Text(
                            message ? 'Joined' : 'Join Event',
                            style: TextStyle(color: Colors.white)),
                        loading: () => const CircularProgressIndicator(
                            color: Colors.white),
                        error: (error, stack) => Text(error.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Share Event Logic
                      final shareContent =
                          'Check out this event: ${widget.event.title} at ${widget.event.location} on ${widget.event.date.day} ${DateFormat('MMM yyyy').format(widget.event.date)}!';
                      // Call share functionality here
                      print(shareContent);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),
                    child: Icon(Icons.share, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

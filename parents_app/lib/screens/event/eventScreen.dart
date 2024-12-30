import 'package:carousel_slider/carousel_slider.dart';
import 'package:class_finder/constants.dart';
import 'package:class_finder/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/eventProvider.dart';
import '../../providers/joinEventProvider.dart';

class EventsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventProvider);
    final user = ref.watch(userDetailsProvider);
    final joinEventState = ref.watch(joinEventProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for modern look
      body: eventState.when(
        data: (events) {
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              print(event.id);
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.eventMedia.isNotEmpty)
                      Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                viewportFraction: 1,
                                enableInfiniteScroll: true,
                                autoPlay: true
                                // enableInfiniteScroll: false,
                                // enlargeCenterPage: true,
                                ),
                            items: event.eventMedia.map((media) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                child: Image.network(
                                  frontEndUrl + "/" + media.url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            }).toList(),
                          ),
                          Positioned(
                            top: 100,
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.only(
                                //     bottomLeft: Radius.circular(20),
                                //     bottomRight: Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.55),
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              event.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${event.date.day} ${DateFormat('MMM').format(event.date)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  Text(
                                    '${event.date.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(
                                'Location: ${event.location}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.description,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.5,
                                  color: Colors.grey[800],
                                ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(joinEventProvider.notifier)
                                    .joinEvent(event.id, user!.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

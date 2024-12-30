import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/event.dart';

final eventProvider =
    StateNotifierProvider<EventNotifier, AsyncValue<List<Event>>>((ref) {
  return EventNotifier();
});

class EventNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  EventNotifier() : super(AsyncValue.loading()) {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/events/class/2'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Event> events =
            jsonResponse.map((event) => Event.fromJson(event)).toList();
        state = AsyncValue.data(events);
      } else {
        state = AsyncValue.error('Failed to load events', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

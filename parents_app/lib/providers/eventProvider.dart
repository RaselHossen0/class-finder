import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';

final pagedEventsProvider = Provider<PagingController<int, Event>>((ref) {
  final controller = PagingController<int, Event>(firstPageKey: 1);

  controller.addPageRequestListener((pageKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse(
        'http://localhost:3000/events?page=$pageKey&limit=3',
      );

      final response = await http.get(url, headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      // print('response: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = parseResponse(response.body);
        print('parsedResponse: $parsedResponse');
        final newItems = parsedResponse['events'] as List<Event>;
        final isLastPage = pageKey >= parsedResponse['totalPages'];

        if (isLastPage) {
          controller.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          controller.appendPage(newItems, nextPageKey);
        }
      } else {
        controller.error = 'Failed to load events';
      }
    } catch (e) {
      print('Error: $e');
      controller.error = e;
    }
  });

  return controller;
});
Map<String, dynamic> parseResponse(String responseBody) {
  final data = json.decode(responseBody);
  final events = (data['data'] as List)
      .map((eventData) => Event.fromJson(eventData))
      .toList();
  return {
    'events': events,
    'totalPages': data['totalPages'],
  };
}

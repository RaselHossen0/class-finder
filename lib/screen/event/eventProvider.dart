import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../Global.dart';
import '../../models/event.dart';

final pagedEventsProvider = Provider<PagingController<int, Event>>((ref) {
  final controller = PagingController<int, Event>(firstPageKey: 1);

  Future<void> fetchPage(int pageKey) async {
    try {
      final box = GetStorage();
      final token = await box.read('token');
      final user = Get.find<cont>().user;
      print('classid: ${user.classId}');

      if (user.classId == null) {
        print('Class ID is null');
        throw Exception('Class ID is null');
      }

      final url = Uri.parse(
        '$rootApi/events/class/${user.classId}?page=$pageKey',
      );
      print('URL: $url');

      final response = await http.get(url, headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = parseResponse(response.body);
        print('Parsed Response: $parsedResponse');
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
        print('Error: ${controller.error}');
      }
    } catch (e) {
      print('Errorss: $e');
      controller.error = e;
    }
  }

  // Listen for page requests
  controller.addPageRequestListener((pageKey) {
    fetchPage(pageKey);
  });

  // Expose a refresh method
  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});

// Refresh Method
Future<void> refreshEvents(WidgetRef ref) async {
  final controller = ref.read(pagedEventsProvider);
  controller.refresh(); // Clears all data and fetches the first page
}

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

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  final String baseUrl = 'https://classroom-api.raselhossen.tech';

  Future<void> deleteEvent(int eventId, String token) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response: ${response.body}');

      if (response.statusCode == 403) {
        throw Exception('Access denied, no token provided');
      } else if (response.statusCode != 200) {
        throw Exception('Failed to delete event');
      }

      EasyLoading.showSuccess('Event deleted successfully');
    } catch (e) {
      print('Error: $e');
      EasyLoading.showError('Error: $e');
      throw e;
    } finally {
      EasyLoading.dismiss();
    }
  }
}

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/class.dart';
import 'filter_provider.dart';
import 'locationServiceProvider.dart';

final classSearchProvider =
    StateNotifierProvider<ClassSearchNotifier, String>((ref) {
  return ClassSearchNotifier();
});

class ClassSearchNotifier extends StateNotifier<String> {
  ClassSearchNotifier() : super(''); // Default to empty string for no search

  void updateSearchQuery(String query) {
    state = query;
    print(state);
  }
}

final pagedClassesProvider = Provider<PagingController<int, ClassModel>>((ref) {
  final controller = PagingController<int, ClassModel>(firstPageKey: 1);

  controller.addPageRequestListener((pageKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final location = await ref.read(locationNotifierProvider);
      final searchQuery = ref.read(classSearchProvider); // Fetch search query
      final filterState = ref.read(filterProvider); // Fetch filter state
      print('Filter state: ${filterState.priceRange}');
      location.when(
        data: (location) async {
          final latitude = location['latitude'];
          final longitude = location['longitude'];
          final token = prefs.getString('token');

          // Build the URL with query and filter parameters
          final url = Uri.parse(
              'http://localhost:3000/classes/get/all?page=$pageKey&limit=3&coordinates=[$latitude,$longitude]&search=$searchQuery&minPrice=${filterState.priceRange}&maxPrice=${filterState.priceRangeMax}&category=${filterState.category}&distance=${filterState.distanceRange}');

          final response = await http.get(
            url,
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            final parsedResponse = parseResponse(response.body);

            final newItems = parsedResponse['classes'];
            final isLastPage = pageKey >= parsedResponse['totalPages'];

            if (isLastPage) {
              controller.appendLastPage(newItems);
            } else {
              final nextPageKey = pageKey + 1;
              controller.appendPage(newItems, nextPageKey);
            }
          } else {
            controller.error = 'Failed to load classes';
          }
        },
        loading: () => {},
        error: (error, stack) {
          controller.error = 'Failed to load location';
        },
      );
    } catch (e) {
      controller.error = e;
    }
  });

  return controller;
});
Map<String, dynamic> parseResponse(String responseBody) {
  final data = json.decode(responseBody);
  final classes = (data['classes'] as List)
      .map((classData) => ClassModel.fromJson(classData))
      .toList();
  return {
    'classes': classes,
    'totalPages': data['totalPages'],
    'page': data['page'],
  };
}

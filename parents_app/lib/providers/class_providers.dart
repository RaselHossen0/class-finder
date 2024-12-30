import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/class.dart';
import 'locationServiceProvider.dart';

final classesProvider = FutureProvider<List<ClassModel>>((ref) async {
  const baseUrl = 'http://localhost:3000/classes/get/all';
  final prefs = await SharedPreferences.getInstance();
  final location = await ref.watch(locationNotifierProvider);

  return location.when(
    data: (location) async {
      final latitude = location['latitude'];
      final longitude = location['longitude'];
      final token = prefs.getString('token');

      // Construct URL with coordinates and other query params
      final url = Uri.parse(
          '$baseUrl?page=1&limit=10&coordinates=[$latitude,$longitude]');

      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        return parseClasses(response.body);
      } else {
        throw Exception('Failed to load classes');
      }
    },
    loading: () => [],
    error: (error, stack) => throw Exception('Failed to load location'),
  );
});

// Helper to parse the response into a list of ClassModel objects
List<ClassModel> parseClasses(String responseBody) {
  final data = json.decode(responseBody);
  return (data['classes'] as List)
      .map((classData) => ClassModel.fromJson(classData))
      .toList();
}

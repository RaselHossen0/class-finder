import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/rating.dart';

final ratingProvider =
    StateNotifierProvider<RatingNotifier, AsyncValue<List<Rating>>>((ref) {
  return RatingNotifier();
});

class RatingNotifier extends StateNotifier<AsyncValue<List<Rating>>> {
  RatingNotifier() : super(const AsyncValue.loading());

  final String baseUrl = 'https://classroom-api.raselhossen.tech/api/ratings';

  Future<void> fetchRatings(int classId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$classId'), headers: {
        'accept': 'application/json',
      });
      print('RatingNotifier: fetchRatings: response: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        final ratings = jsonData.map((json) => Rating.fromJson(json)).toList();
        state = AsyncValue.data(ratings);
      } else {
        state = AsyncValue.error('Failed to fetch ratings', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error('An error occurred: $e', StackTrace.current);
    }
  }

  Future<void> addRating(Map<String, dynamic> ratingData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(ratingData),
      );
      if (response.statusCode == 201) {
        fetchRatings(ratingData['classId']);
      } else {
        throw Exception('Failed to add rating');
      }
    } catch (e) {
      state = AsyncValue.error('An error occurred: $e', StackTrace.current);
    }
  }
}

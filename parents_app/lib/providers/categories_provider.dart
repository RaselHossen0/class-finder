import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = await prefs.getString('token');
  const url =
      'http://localhost:3000/categories'; // Replace with your actual API URL
  final response = await http.get(Uri.parse(url), headers: {
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => Category.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
});

class Category {
  final int id;
  final String name;
  final String? logo; // Logo can be nullable

  Category({required this.name, this.logo, required this.id});

  factory Category.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Category(
      id: json['id'],
      name: json['name'],
      logo: json['logo'], // Assuming the logo URL comes from the API
    );
  }
}

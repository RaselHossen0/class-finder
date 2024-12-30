import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UserState {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool adminVerified;
  final String createdAt;
  final String updatedAt;
  final String profileImage;
  bool isDarkMode = false;

  UserState({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.adminVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.profileImage,
    this.isDarkMode = false,
  });

  factory UserState.fromJson(Map<String, dynamic> json) {
    return UserState(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      adminVerified: json['adminVerified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'adminVerified': adminVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'profileImage': profileImage,
    };
  }
}

class UserDetailsNotifier extends StateNotifier<UserState?> {
  UserDetailsNotifier() : super(null);

  Future<void> fetchUserDetails(String token) async {
    final url = Uri.parse('http://localhost:3000/auth/user-details');

    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == 0) {
          final user = UserState.fromJson(data['user']);
          state = user; // Update the state with the fetched user
          print('User details fetched successfully');
        } else {
          throw Exception('Failed to fetch user details');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Log or handle error as necessary
      state = null; // Clear state in case of error
      rethrow; // Rethrow the error if you need to handle it elsewhere
    }
  }

  void setUserDetails(UserState user) {
    state = user;
  }

  void clearUserDetails() {
    state = null;
  }
}

final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, UserState?>(
  (ref) => UserDetailsNotifier(),
);

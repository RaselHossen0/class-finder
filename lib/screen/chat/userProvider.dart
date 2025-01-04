import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Global.dart';

class UserState {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool adminVerified;
  final String createdAt;
  final String updatedAt;
  final String profileImage;
  bool isDarkMode;

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
      profileImage: rootApi + "/" + json['profileImage'],
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

class UserController extends GetxController {
  // Observable user state
  var user = Rxn<UserState>();

  // Fetch user details
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
          final fetchedUser = UserState.fromJson(data['user']);
          user.value = fetchedUser; // Update the observable user state
          print('User details fetched successfully');
        } else {
          throw Exception('Failed to fetch user details');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user details: $error');
      user.value = null; // Clear user data on error
    }
  }

  // Set user details
  void setUserDetails(UserState userDetails) {
    user.value = userDetails;
  }

  // Clear user details
  void clearUserDetails() {
    user.value = null;
  }
}

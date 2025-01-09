import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final String? otp;
  final String? email;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.otp,
    this.email,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> sendOtp(String email) async {
    state = AuthState(isLoading: true);
    try {
      final response = await http.post(
        Uri.parse('https://classroom-api.raselhossen.tech/auth/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['error'] == 0) {
          state = AuthState(
              successMessage: data['message'],
              otp: data['otp'].toString(),
              email: email);
          print(state.email);
        } else {
          state = AuthState(errorMessage: data['message']);
        }
      } else {
        state = AuthState(errorMessage: 'Failed to send OTP');
      }
    } catch (e) {
      print(e);
      state = AuthState(errorMessage: 'Failed to send OTP');
    }
  }

  Future<void> changePassword(String password, String email) async {
    state = AuthState(isLoading: true);

    try {
      final response = await http.post(
        Uri.parse(
            'https://classroom-api.raselhossen.tech/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['error'] == 0) {
          state = AuthState(successMessage: data['message']);
        } else {
          state = AuthState(errorMessage: data['message']);
        }
      } else {
        state = AuthState(errorMessage: 'Failed to change password');
      }
    } catch (e) {
      state = AuthState(errorMessage: 'Failed to change password');
    }
  }
}

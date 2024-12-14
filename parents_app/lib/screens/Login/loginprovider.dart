import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final String? token;

  LoginState({this.isLoading = false, this.errorMessage, this.token});
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState());

  Future<void> login(String email, String password) async {
    state = LoginState(isLoading: true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/login'),
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
        print(data);
        state = LoginState(token: data['token']);
      } else {
        state = LoginState(
            errorMessage:
                json.decode(response.body)["error"] ?? 'Login failed');
      }
    } catch (e) {
      state = LoginState(errorMessage: 'Login failed');
    }
  }
}

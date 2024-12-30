import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final signupProvider =
    StateNotifierProvider<SignupNotifier, AsyncValue<String>>(
  (ref) => SignupNotifier(),
);

class SignupNotifier extends StateNotifier<AsyncValue<String>> {
  SignupNotifier() : super(const AsyncValue.data(''));

  Future<void> signUp(
      String name, String email, String password, String role) async {
    final url = Uri.parse('http://localhost:3000/auth/signup');
    print('name: $name, email: $email, password: $password, role: $role');
    state = const AsyncValue.loading();
    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );
      print(response.body);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        state = AsyncValue.data(data['message']);
      } else if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = AsyncValue.error(data['message'], StackTrace.current);
      } else {
        state =
            AsyncValue.error('User registration failed', StackTrace.current);
      }
    } catch (error) {
      state = AsyncValue.error('An error occurred: $error', StackTrace.current);
    }
  }
}

import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    EasyLoading.show(status: 'Logging in...');
    state = LoginState(isLoading: true, token: null, errorMessage: null);
    try {
      final response = await http.post(
        Uri.parse('https://classroom-api.raselhossen.tech/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == 0) {
          state = LoginState(
            token: data['token'],
          );
          print(state.token);
          EasyLoading.showSuccess(data['message']);
        } else {
          state = LoginState(errorMessage: data['message']);
          EasyLoading.showError(data['message']);
        }
      } else {
        final errorMessage =
            json.decode(response.body)["message"] ?? 'Login failed';
        state = LoginState(errorMessage: errorMessage);
        EasyLoading.showError(errorMessage);
      }
    } catch (e) {
      state = LoginState(errorMessage: 'Login failed');
      EasyLoading.showError('Login failed');
    } finally {
      EasyLoading.dismiss();
      state = LoginState(isLoading: false);
    }
  }
}

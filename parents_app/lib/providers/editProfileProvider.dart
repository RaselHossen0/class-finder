// lib/providers/edit_profile_provider.dart
import 'dart:convert';

import 'package:class_finder/providers/user_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>((ref) {
  return EditProfileNotifier();
});

class EditProfileState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final UserState? user;

  EditProfileState(
      {this.isLoading = false,
      this.errorMessage,
      this.successMessage,
      this.user});
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier() : super(EditProfileState());

  Future<void> editProfile({
    required String email,
    String? name,
    String? mobileNumber,
    String? alternateMobileNumber,
    String? aadhaarCardNumber,
    String? panCardNumber,
    String? password,
    String? profileImagePath,
  }) async {
    state = EditProfileState(isLoading: true);
    EasyLoading.show(status: 'Updating profile...');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://classroom-api.raselhossen.tech/auth/edit-profile'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['email'] = email;
      if (name != null) request.fields['name'] = name;
      if (mobileNumber != null) request.fields['mobileNumber'] = mobileNumber;
      if (alternateMobileNumber != null)
        request.fields['alternateMobileNumber'] = alternateMobileNumber;
      if (aadhaarCardNumber != null)
        request.fields['aadhaarCardNumber'] = aadhaarCardNumber;
      if (panCardNumber != null)
        request.fields['panCardNumber'] = panCardNumber;
      if (password != null) request.fields['password'] = password;
      if (profileImagePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profileImage', profileImagePath));
      }

      final response = await request.send();
      print(response.statusCode);
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      print(data);

      if (response.statusCode == 200 && data['error'] == 0) {
        state = EditProfileState(successMessage: data['message']);

        EasyLoading.showSuccess(data['message']);
      } else {
        state = EditProfileState(
            errorMessage: data['message'],
            user: UserState.fromJson(data['user']));
        EasyLoading.showError(data['message']);
      }
    } catch (e) {
      state = EditProfileState(errorMessage: 'Failed to update profile');
      EasyLoading.showError('Failed to update profile');
    } finally {
      // state = EditProfileState(isLoading: false);
      EasyLoading.dismiss();
    }
  }
}

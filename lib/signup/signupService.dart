import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';

import 'package:dio/dio.dart';
import 'package:class_rasel/Global.dart';

signup(String firstName,String email,String pass, String role) async {
  Dio dio = Dio();

  // Define the API URL
   String apiUrl = '$rootApi/auth/signup';

  // Define the request payload
  Map<String, dynamic> data = {
    "name": firstName,
    "email": email,
    "password": pass,
    "role": role
  };

  try {
    // Send the POST request
    Response response = await dio.post(
      apiUrl,
      data: data,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Print response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response;
  } catch (e) {
    // Handle errors
    print('Error: $e');
  }
}

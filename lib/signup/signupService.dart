import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';

import 'package:dio/dio.dart';

signupService(String name,String email,String pass) async {
  var dio = Dio();
  print("           11111            ");
  try {
    var response = await dio.post(
      '$rootApi/auth/signup',
      data: {
        'name': name,
        'email': email,
        'password': pass,
        'role': 'user'
      },
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('Response: ${response.data}');
    return response;
  } catch (e) {
    print('Error: $e');
  }
}


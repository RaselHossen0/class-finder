import 'package:dio/dio.dart';

import 'Global.dart';

final dio = Dio();





LoginService(String email,String pass) async {
  var data = {
    "email": email,
    "password": pass,
  };

  var alu;
  //print("          1111111         ");
  try {
    //print("          1111111         ");
    Response response = await dio.post(
      'http://10.0.2.2:3000/auth/login',
      data: data,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );


    // Check the response
    print("          1111111         ");
    if (response.statusCode == 200) {
      print('Login successful: ${response.data}');
    } else {
      print('Login failed: ${response.statusMessage}');
    }
    print("          1111111         ");
    return response;
  } catch (e) {
    print('Error: $e');

  }
}


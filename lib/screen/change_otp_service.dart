import 'package:dio/dio.dart';
import 'package:class_rasel/Global.dart';

Future<dynamic> sendOtpAlu(String email) async {
  Dio dio = Dio();

  // Define API endpoint
  String url = '$rootApi/auth/send-otp';

  try {
    // Make POST request
    Response response = await dio.post(
      url,
      data: {"email": email},
      options: Options(
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    // Check the response status code
    if (response.statusCode == 200) {
      print('OTP sent successfully: ${response.data}');
      return response.data;
    } else {
      print('Failed to send OTP: ${response.data}');
      return null; // You can return null or some error message if the status code is not 200
    }
  } on DioError catch (e) {
    // Handle Dio specific errors
    print('Dio error occurred: ${e.message}');
    if (e.response != null) {
      print('Response data: ${e.response?.data}');
    }
    return null; // You can return null or throw a custom exception
  } catch (e) {
    // Handle other types of errors
    print('Error occurred: $e');
    return null;
  }
}



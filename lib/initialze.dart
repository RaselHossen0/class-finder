import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';

fetchUserDetails(String token) async {
  final dio = Dio();

  try {
    final response = await dio.get(
      '$rootApi/auth/user-details',
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    print('Response data: ${response.data}');
    return response.data;
  } catch (e) {
    print('Error: $e');
  }
}

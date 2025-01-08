import 'dart:convert';
import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiService {
   String baseUrl = rootApi;
  static const String userDetailsEndpoint = '/auth/user-details';

  Future<Map<String, dynamic>> fetchUserDetails(String token) async {
    final url = Uri.parse('$baseUrl$userDetailsEndpoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }
}



updateClassOwner(String tk,String key,String value) async {
  final dio = Dio();

  // API endpoint
  String url = rootApi;

  // Headers
  var headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer $tk',
    'Content-Type': 'application/json',
  };

  // Body data
  var data = {
    "$key": "$value",

  };

  try {
    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: headers),
    );

    // Handle the response
    print('Response: ${response.data}');
    return response;
  } catch (e) {
    // Handle error
    print('Error: $e');
  }
}


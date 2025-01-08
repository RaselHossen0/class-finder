import 'dart:convert';

import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

fetchChatHistoryData(int userId) async {
  final dio = Dio();
  print('user id: $userId');
  try {
    final response = await dio.get(
      '$rootApi/chats/user/$userId',
      options: Options(
        headers: {
          'accept': 'application/json',
        },
      ),
    );

    print(response.data);
    return response;
  } catch (e) {
    print('Error: $e'); // Handle errors
  }
}

// Future<int> createChat(int userId, int classOwnerId,String tk) async {
//   try {
//     final token = tk;
//     final response = await http.post(
//       Uri.parse('$baseUrl/chats/create'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: json.encode({
//         'userId': userId,
//         'classOwnerId': classOwnerId,
//       }),
//     );
//     print(response.body);
//
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       final data = await json.decode(response.body);
//       return await data['chatId'] ?? data['id'];
//     } else {
//       throw Exception('Failed to create chat: ${response.body}');
//     }
//   } catch (error) {
//     throw Exception('Error creating chat room: $error');
//   }
// }



// startChat(String tk,int classOwner,int userId) async {
//   final dio = Dio();
//   final url = '$rootApi/chats/start';
//
//   try {
//     final response = await dio.post(
//       url,
//       options: Options(
//         headers: {
//           'accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       ),
//       data: {
//         "userId": userId,
//         "classOwnerId": classOwner,
//       },
//     );
//
//     // Print the response
//     print('Response status: ${response.statusCode}');
//     print('Response data: ${response.data}');
//     return await response.data["chatId"]??response.data["id"];
//   } catch (e) {
//     print("                   goya mara             ");
//     print('Error: $e');
//   }
// }
Future<int> createChat(int userId, int classOwnerId,String token) async {
  try {

    final response = await http.post(
      Uri.parse('$rootApi/chats/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'userId': userId,
        'classOwnerId': classOwnerId,
      }),
    );
    print(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = await json.decode(response.body);
      return await data['chatId'] ?? data['id'];
    } else {
      throw Exception('Failed to create chat: ${response.body}');
    }
  } catch (error) {
    throw Exception('Error creating chat room: $error');
  }
}
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message.dart';

class ChatRepository {
  final String baseUrl;

  ChatRepository({required this.baseUrl});

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Message>> fetchMessages(int chatId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/chats/messages/chat/$chatId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    // print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((msg) => Message.fromJson(msg)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  Future<int> createChat(int userId, int classOwnerId) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/chats/create'),
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

  Future<void> sendMessage(int chatId, int senderId, String content) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/chats/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}

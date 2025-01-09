import 'package:get/get.dart';

import 'chat_service.dart';

class ChatHistoryData {
  final int id;
  final int userId;
  final int classOwnerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final List<Message> messages;

  ChatHistoryData({
    required this.id,
    required this.userId,
    required this.classOwnerId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.messages,
  });

  factory ChatHistoryData.fromJson(Map<String, dynamic> json) {
    return ChatHistoryData(
      id: json['id'],
      userId: json['userId'],
      classOwnerId: json['classOwnerId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['User']),
      messages: (json['Messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }
}

class Message {
  final int id;
  final int chatId;
  final int senderId;
  final String content;
  final String attachmentUrl;
  final bool isRead;
  final bool isReply;
  final int repliedToId;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.attachmentUrl,
    required this.isRead,
    required this.isReply,
    required this.repliedToId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      attachmentUrl: json['attachmentUrl'] ?? '',
      isRead: json['isRead'],
      isReply: json['isReply'],
      repliedToId: json['repliedToId'] ?? -1,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatHistoryController extends GetxController {
  var chatHistory = <ChatHistoryData>[].obs;

  Future<void> fetchChatHistory(int userId) async {
    try {
      final result = await fetchChatHistoryData(userId); // API call function
      chatHistory.clear();
      chatHistory.addAll(
        (result.data as List)
            .map((json) => ChatHistoryData.fromJson(json))
            .toList(),
      );
    } catch (e) {
      print("Error fetching chat history: $e");
    }
  }
}

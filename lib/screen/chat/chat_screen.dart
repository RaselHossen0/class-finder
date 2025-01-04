import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';


import '../../Global.dart';
import 'chatProvider.dart';
import 'chatRepo.dart';

class ChatScreen extends StatelessWidget {
  final int chatId;

  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    // Ensure the ChatController is properly initialized
    final ChatController chatController = Get.put(
      ChatController(chatRepository: ChatRepository(baseUrl: rootApi)),
    );

    // Fetch messages for the chat ID
    chatController.fetchMessages(chatId);

    final cont chatS= Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Color(0xff1f1c38),
        title: Text(
          'Chat with Instructor',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (chatController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatMessages = chatController.chatMessages.map((msg) {
          final author =
          types.User(id: msg.senderId.toString(), firstName: 'Instructor');
          return types.TextMessage(
            id: msg.id.toString(),
            author: author,
            text: msg.content,
            createdAt: msg.timestamp.millisecondsSinceEpoch,
          );
        }).toList();

        final currentUser = types.User(
          id: chatS.userId.toString(),
          firstName: chatS.user.name,
        );

        return Chat(
          messages: chatMessages.reversed.toList(),
          onSendPressed: (partialMessage) =>
              _handleSendMessage(partialMessage, currentUser, chatController),
          showUserAvatars: true,
          showUserNames: true,
          theme: DarkChatTheme(),
          user: currentUser,
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
        );
      }),
    );
  }

  void _handleSendMessage(
      types.PartialText partialMessage,
      types.User currentUser,
      ChatController chatController,
      ) {
    chatController.sendMessage(
      chatId: chatId,
      senderId: int.parse(currentUser.id),
      content: partialMessage.text,
    );
  }
}

import 'package:class_rasel/Global.dart';
import 'package:class_rasel/screen/chat/chat_history_data.dart';
import 'package:class_rasel/screen/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHistoryScreen extends StatelessWidget {
  final ChatHistoryController chatController = Get.put(ChatHistoryController());

  ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    chatController.fetchChatHistory(1); // Fetch initial data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality
            },
          ),
        ],
      ),
      body: Obx(() {
        if (chatController.chatHistory.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: chatController.chatHistory.length,
          itemBuilder: (context, index) {
            final chat = chatController.chatHistory[index];
            final lastMessage =
                chat.messages.isNotEmpty ? chat.messages.last : null;

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "$rootApi/${chat.user.profileImage}",
                ),
              ),
              title: Text(chat.user.name),
              subtitle: Text(
                lastMessage != null ? lastMessage.content : 'No messages yet',
                style: TextStyle(
                  fontWeight: lastMessage?.isRead ?? true
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
              trailing: Text(
                lastMessage != null
                    ? "${lastMessage.timestamp.hour}:${lastMessage.timestamp.minute}"
                    : '',
              ),
              onTap: () {
                Get.to(ChatScreen(chatId: chat.id));
                // Navigate to chat details screen
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //go to

          // Add functionality for new chat
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}

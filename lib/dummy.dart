import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<Map<String, dynamic>> chats = [];

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  // Simulate fetching chat data
  void _loadChatData() {
    // Simulated JSON response
    final jsonResponse = {
      "User": {
        "id": 10,
        "name": "John Doe",
        "email": "hr@gmail.com",
        "profileImage": "uploads/1735847330783-560081647.jpg"
      },
      "Messages": [
        {
          "id": 1,
          "chatId": 2,
          "senderId": 10,
          "content": "Hi",
          "attachmentUrl": "",
          "isRead": false,
          "isReply": true,
          "repliedToId": -1,
          "timestamp": "2025-01-02T17:50:48.000Z",
          "createdAt": "2025-01-02T17:50:48.000Z",
          "updatedAt": "2025-01-02T17:50:48.000Z"
        },
        {
          "id": 2,
          "chatId": 2,
          "senderId": 11,
          "content": "Hello! How are you?",
          "attachmentUrl": "",
          "isRead": true,
          "isReply": false,
          "repliedToId": -1,
          "timestamp": "2025-01-02T17:55:48.000Z",
          "createdAt": "2025-01-02T17:55:48.000Z",
          "updatedAt": "2025-01-02T17:55:48.000Z"
        }
      ]
    };

    // Parse and populate chats list
    final user = jsonResponse["User"];
    final messages = jsonResponse["Messages"] as List;

    chats = messages.map((message) {
      return {
        "name": user?["name"],
        "message": message["content"],
        "time": _formatTimestamp(message["timestamp"]),
        "avatar": user["profileImage"],
        "isReply": message["isReply"],
        "isRead": message["isRead"],
      };
    }).toList();

    setState(() {});
  }

  // Helper method to format the timestamp
  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: chats.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loader while chats are loading
          : ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          final isReply = chat["isReply"];
          final isRead = chat["isRead"];
          final messagePrefix = isReply ? "You:" : "${chat['name']}:";
          final messageText = "$messagePrefix ${chat['message']}";

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://example.com/${chat['avatar']}", // Replace with the correct base URL
              ),
            ),
            title: Text(
              chat['name'],
            ),
            subtitle: Text(
              messageText,
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            trailing: Text(chat['time']),
            onTap: () {
              // Navigate to chat details screen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for new chat
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}

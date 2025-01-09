import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../Global.dart';
import 'chatRepo.dart';
import 'message.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository;

  // Observable state
  final chatMessages = <Message>[].obs;
  final isLoading = false.obs;

  // WebSocket instance
  late IO.Socket socket;

  ChatController({required this.chatRepository});

  /// Fetch messages for a specific chat
  Future<void> fetchMessages(int chatId) async {
    try {
      isLoading.value = true;
      final messages = await chatRepository.fetchMessages(chatId);
      chatMessages.assignAll(messages);
    } catch (error) {
      Get.snackbar('Error', 'Failed to fetch messages: $error');
    } finally {
      isLoading.value = false;
    }
  }

  /// Setup WebSocket connection for real-time updates
  void setupSocket(int chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');
    socket = IO.io(
      '$rootApi',
      IO.OptionBuilder().setTransports(['websocket']) // Use WebSocket transport
          .setExtraHeaders({'Authorization': 'Bearer $token'}) // Add headers
          .build(),
    );

    socket.onConnect((_) {
      print('Connected to WebSocket');
      fetchMessages(chatId); // Fetch messages upon connecting
      socket.emit('joinRoom', {'chatId': chatId}); // Join the chat room
    });

    socket.on('newMessage', (data) {
      print('New message received: $data');
      if (data['error'] != null) {
        print('Error: ${data['error']}');
        return;
      }
      // Add new message to the chat
      chatMessages.insert(0, Message.fromJson(data['message']));
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
      socket.dispose();
    });
  }

  /// Send a message via WebSocket
  Future<void> sendMessage({
    required int chatId,
    required int senderId,
    required String content,
  }) async {
    try {
      socket.emit('sendMessage', {
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
      });
      // Add the message locally to display immediately
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch,
        chatId: chatId,
        senderId: senderId,
        content: content,
        isReply: false,
        repliedToId: null,
        isRead: true,
        timestamp: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        attachmentUrl: '',
      );
      chatMessages.insert(0, newMessage);
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}

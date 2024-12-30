import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/message.dart';
import 'chatRepo.dart';

final createChatProvider =
    FutureProvider.family<int, Map<String, int>>((ref, params) async {
  final chatRepository = ref.read(chatRepositoryProvider);
  final userId = params['userId']!;
  final classOwnerId = params['classOwnerId']!;
  return await chatRepository.createChat(userId, classOwnerId);
});
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    baseUrl: 'http://localhost:3000',
  );
});

final chatMessagesProvider =
    StateNotifierProvider<ChatNotifier, List<Message>>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatNotifier(chatRepository);
});

class ChatNotifier extends StateNotifier<List<Message>> {
  final ChatRepository repository;
  late IO.Socket socket;

  ChatNotifier(this.repository) : super([]);

  Future<void> fetchMessages(int chatId) async {
    try {
      final messages = await repository.fetchMessages(chatId);
      state = messages;
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void setupSocket(int chatId) {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      // 'extraHeaders': {'Authorization': 'Bearer YOUR_AUTH_TOKEN'},
    });

    socket.onConnect((_) {
      print('Connected to socket');
      fetchMessages(chatId);
      socket.emit('joinRoom', {'chatId': chatId});
    });

    socket.on('newMessage', (data) {
      print('New message: $data');
      if (data['error'] != null) {
        print('Error: ${data['error']}');
        return;
      }
      print('New messagesssss: ${data['message']}');
      state = [...state, Message.fromJson(data['message'])];
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket');
      state = [];
      socket.dispose();
    });
  }

  Future<void> sendMessage(int chatId, int senderId, String content,
      String attachmentUrl, bool isReply, int repliedTo) async {
    try {
      // await repository.sendMessage(chatId, senderId, content);
      socket.emit('sendMessage', {
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
        'attachmentUrl': attachmentUrl,
        'isReply': isReply,
        'repliedToId': repliedTo,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}

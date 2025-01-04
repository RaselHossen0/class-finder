// import 'package:get/get.dart';
// import 'chatRepo.dart';
// import 'message.dart';
//
// class ChatController extends GetxController {
//   final ChatRepository chatRepository;
//   final chatMessages = <Message>[].obs;
//   final isLoading = false.obs;
//
//   ChatController({required this.chatRepository});
//
//   /// Fetch messages for a given chat
//   Future<void> fetchMessages(int chatId) async {
//     try {
//       isLoading.value = true;
//       final messages = await chatRepository.fetchMessages(chatId);
//       chatMessages.assignAll(messages);
//     } catch (error) {
//       Get.snackbar('Error', 'Failed to fetch messages: $error');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Send a message and update the local chat list
//   Future<void> sendMessage(int chatId, int senderId, String content) async {
//     try {
//       await chatRepository.sendMessage(chatId, senderId, content);
//       final newMessage = Message(
//         id: DateTime.now().millisecondsSinceEpoch, // Temporary ID for local use
//         chatId: chatId,
//         senderId: senderId,
//         content: content,
//         attachmentUrl: '', // Default value for now
//         isReply: false, // Assuming it's not a reply
//         repliedToId: null, // No reply reference
//         isRead: true, // Marking as read locally
//         timestamp: DateTime.now(),
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//       chatMessages.insert(0, newMessage); // Add message to the list
//     } catch (error) {
//       Get.snackbar('Error', 'Failed to send message: $error');
//     }
//   }
// }

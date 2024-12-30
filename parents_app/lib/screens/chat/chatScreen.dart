import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/chatProvider.dart';
import '../../providers/user_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int chatId;

  ChatScreen({required this.chatId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    chatNotifier.setupSocket(widget.chatId);
  }

  // @override
  // void dispose() {
  //   print('Chat screen disposed');
  //
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // Watch chat messages and user details
    final messages = ref.watch(chatMessagesProvider);
    final user = ref.watch(userDetailsProvider);

    // Convert existing messages into flutter_chat_ui compatible messages
    final chatMessages = messages.map((msg) {
      final author =
          types.User(id: msg.senderId.toString(), firstName: 'Instructor');
      if ('text' == 'text') {
        return types.TextMessage(
          id: msg.id.toString(),
          author: author,
          text: msg.content,
          createdAt: msg.createdAt.millisecondsSinceEpoch,
        );
      }
      // Add more message types if needed
      return types.CustomMessage(id: msg.id.toString(), author: author);
    }).toList();

    // Current user for flutter_chat_ui
    final currentUser =
        types.User(id: user?.id.toString() ?? '0', firstName: user?.name);

    return PopScope(
      onPopInvokedWithResult: (result, res) {
        print('Pop invoked with result: $result');
        final chatNotifier = ref.read(chatMessagesProvider.notifier);
        // chatNotifier.dispose();
        chatNotifier.socket.disconnect();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xff1f1c38),
          title: Text(
            'Chat with Instructor',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        body: Chat(
          messages: chatMessages.reversed.toList(),
          onAttachmentPressed: () => _handleAttachmentPressed(context, ref),
          onSendPressed: (partialMessage) => _handleSendMessage(
              partialMessage, ref, widget.chatId, currentUser),
          showUserAvatars: true,
          showUserNames: true,
          theme: DarkChatTheme()
          // DefaultChatTheme(
          //   inputBackgroundColor: Colors.white,
          //   inputTextColor: Colors.black,
          //   inputContainerDecoration: BoxDecoration(
          //     color: Colors.white10,
          //     border: Border.all(color: Colors.grey),
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   inputBorderRadius: BorderRadius.circular(20),
          //   inputTextCursorColor: Colors.blue,
          //   attachmentButtonIcon: Icon(Icons.attach_file, color: Colors.blue),
          //   sendButtonIcon: Icon(Icons.send, color: Colors.blue),
          //
          //   // inputContainerDecoration: BoxDecoration(
          //   //   border: Border.all(color: Colors.grey),
          //   //   borderRadius: BorderRadius.circular(20),
          //   // ),
          // )
          ,
          user: currentUser,
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }

  void _handleAttachmentPressed(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(context, ref);
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickFile(context, ref);
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, WidgetRef ref) {
    // Implement image selection and call a method to send an image message
  }

  void _pickFile(BuildContext context, WidgetRef ref) {
    // Implement file selection and call a method to send a file message
  }

  void _handleSendMessage(
    types.PartialText partialMessage,
    WidgetRef ref,
    int chatId,
    types.User currentUser,
  ) {
    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    chatNotifier.sendMessage(
      chatId,
      int.parse(currentUser.id),
      partialMessage.text,
      '', // Attachments URL (if any)
      false, // isReply
      -1, // Replying to message ID (if any)
    );
  }
}

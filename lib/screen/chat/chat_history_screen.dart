import 'package:class_rasel/Global.dart';
import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:class_rasel/screen/chat/chat_history_data.dart';
import 'package:class_rasel/screen/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }
  final cont chatHistory = Get.find();
  final List<ChatHistoryData> chats = [
    // {
    //   'name': 'John Doe',
    //   'message': 'Hey, how are you?',
    //   'time': '10:30 AM',
    //   'avatar': 'https://via.placeholder.com/150'
    // },
    // {
    //   'name': 'Jane Smith',
    //   'message': 'Let\'s catch up later!',
    //   'time': 'Yesterday',
    //   'avatar': 'https://via.placeholder.com/150'
    // },
    // Add more chat data
  ];

  void initialization() async{
    try{
      var result = await fetchChatHistoryData(chatHistory.userId!);
      print(result);
      for(int i=0;i<result.data.lenght;i++){
        var cs=ChatHistoryData(toUserId: result.data[i]["userId"], toUserName: result.data[i]["User"]["name"] , photo: result.data[i]["User"]["profileImage"], finalMessage: result.data[i]["Messages"]["content"], isRead: result.data[i]["Messages"]["isRead"], isReply: result.data[i]["Messages"]["isReply"], time:result.data[i]["Messages"]["timestamp"] );
        chats.add(cs);
      }
    }catch(e){
      print("        in here        ");
      print(e);
    }
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
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          String ph=chat.photo;
          String fullUrl ="$rootApi/$ph";
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                fullUrl, // Replace with the correct base URL
              ),
            ),
            title: Text(
              chat.toUserName,
            ),
            subtitle: Text(
              chat.finalMessage,
              style: TextStyle(
                fontWeight: chat.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            trailing: Text(chat.time),
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

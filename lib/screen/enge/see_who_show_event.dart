import 'package:class_rasel/Global.dart';
import 'package:class_rasel/screen/chat/chat_screen.dart';
import 'package:class_rasel/screen/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../every class/get_controller.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  final cont curr = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final url = Uri.parse('$rootApi/events/${curr.curretEventId}/users');
    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer ${curr.token}'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          _users = responseData.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor),
        ),
      )
          : _users.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : UserCardList(data: _users),
    );
  }
}

class UserCardList extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  UserCardList({required this.data});

  @override
  _UserCardListState createState() => _UserCardListState();
}

class _UserCardListState extends State<UserCardList> {
  bool isLoading3 = false;

  @override
  Widget build(BuildContext context) {
    final cont curr1 = Get.find();

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final user = widget.data[index]['User'];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isLoading3
                  ? null
                  : () async {
                setState(() => isLoading3 = true);
                EasyLoading.show(
                  status: 'Creating chat...',
                  maskType: EasyLoadingMaskType.black,
                );

                try {
                  var result = await createChat(
                      user['id'], curr1.classId!, curr1.token);
                  if (result != null) {
                    Get.to(ChatScreen(chatId: result));
                  }
                } catch (e) {
                  EasyLoading.showError('Failed to create chat');
                } finally {
                  setState(() => isLoading3 = false);
                  EasyLoading.dismiss();
                }
              },
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          'https://classroom-api.raselhossen.tech/${user['profileImage']}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return CircleAvatar(
                              backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            user['email'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.message_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
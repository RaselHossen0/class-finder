class ChatHistoryData {
  int toUserId;
  String toUserName;
  String photo;
  String finalMessage;
  bool isRead;
  bool isReply;
  String time;

  // Default constructor
  ChatHistoryData({
    required this.toUserId,
    required this.toUserName,
    required this.photo,
    required this.finalMessage,
    required this.isRead,
    required this.isReply,
    required this.time,
  });

  // Named constructor for creating instances from JSON


  // Method to convert the object back to JSON

}

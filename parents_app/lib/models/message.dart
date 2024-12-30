class Message {
  final int id;
  final int senderId;
  final int chatId;
  final String content;
  final String attachmentUrl;
  final bool isReply;
  int? repliedToId;
  final bool isRead;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.senderId,
    required this.chatId,
    required this.content,
    required this.attachmentUrl,
    required this.isReply,
    required this.repliedToId,
    required this.isRead,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    print(json);
    return Message(
      id: json['id'] ?? 0,
      senderId: json['senderId'],
      chatId: json['chatId'],
      content: json['content'],
      attachmentUrl: json['attachmentUrl'] ?? '',
      isReply: json['isReply'],
      repliedToId: json['repliedToId'],
      isRead: json['isRead'],
      timestamp: DateTime.parse(json['timestamp']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

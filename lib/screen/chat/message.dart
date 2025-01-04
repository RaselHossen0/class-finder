class Message {
  final int id;
  final int senderId;
  final int chatId;
  final String content;
  final String attachmentUrl;
  final bool isReply;
  final int? repliedToId; // Nullable
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
    this.repliedToId,
    required this.isRead,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory to create an instance from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      senderId: json['senderId'] ?? 0,
      chatId: json['chatId'] ?? 0,
      content: json['content'] ?? '',
      attachmentUrl: json['attachmentUrl'] ?? '',
      isReply: json['isReply'] ?? false,
      repliedToId: json['repliedToId'], // Can remain null
      isRead: json['isRead'] ?? false,
      timestamp: _parseDateTime(json['timestamp']),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  /// Safely parse date strings, handling null or invalid formats
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now(); // Default to current time
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now(); // Fallback for invalid formats
    }
  }
}

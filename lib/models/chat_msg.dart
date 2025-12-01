class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isUser;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isUser,
    this.isLoading = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      timestamp: DateTime.parse(data['timestamp']),
      isUser: data['isUser'] ?? false,
      isLoading: data['isLoading'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
      'isLoading': isLoading,
    };
  }
}

class ChatHistory {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  ChatHistory({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });
}
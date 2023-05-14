class ChatMessage {
  final String id;
  final String senderId;
  final String reciberId;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.reciberId,
    required this.content,
    required this.createdAt,
  });
}

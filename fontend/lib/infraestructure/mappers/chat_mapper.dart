import 'package:study_sphere_frontend/domain/entity/chat.dart';
import 'package:study_sphere_frontend/domain/entity/chat_message.dart';

class ChatMapper {
  static Chat chatsJsonToEntity(Map<String, dynamic> json) => Chat(
        id: json['id'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        avatar: json['avatar'],
      );

  static ChatMessage chatMessageJsonToEntity(Map<String, dynamic> json) =>
      ChatMessage(
        id: json['id'],
        senderId: json['senderId'],
        reciberId: json['reciberId'],
        content: json['content'],
        createdAt: DateTime.parse(json['created_at']),
      );
}

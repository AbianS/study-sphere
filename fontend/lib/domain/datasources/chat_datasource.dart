import 'package:study_sphere_frontend/domain/entity/chat.dart';
import 'package:study_sphere_frontend/domain/entity/chat_message.dart';

abstract class ChatDatasource {
  Future<List<Chat>> getChats(String token);
  Future<List<ChatMessage>> getHistorialChat(String token, String messagerId);
  Future<Chat> getChatUser(String userId);
}

import '../entity/chat.dart';
import '../entity/chat_message.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats(String token);
  Future<List<ChatMessage>> getHistorialChat(String token, String messagerId);
  Future<Chat> getChatUser(String userId);
}

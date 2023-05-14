import 'package:dio/dio.dart';
import 'package:study_sphere_frontend/domain/datasources/chat_datasource.dart';
import 'package:study_sphere_frontend/domain/entity/chat.dart';
import 'package:study_sphere_frontend/domain/entity/chat_message.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/chat_mapper.dart';

import '../../config/constants/enviroment.dart';

class ChatDatasourceImpls extends ChatDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.api_url,
    ),
  );

  @override
  Future<List<Chat>> getChats(String token) async {
    final response = await dio.get<List>(
      '/clases/chats',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final List<Chat> chats = [];
    for (final chat in response.data ?? []) {
      chats.add(ChatMapper.chatsJsonToEntity(chat));
    }
    return chats;
  }

  @override
  Future<List<ChatMessage>> getHistorialChat(
      String token, String messagerId) async {
    final response = await dio.get<List>(
      '/chats/$messagerId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    final List<ChatMessage> chatsMessage = [];
    for (final chatMessage in response.data ?? []) {
      chatsMessage.add(ChatMapper.chatMessageJsonToEntity(chatMessage));
    }
    return chatsMessage;
  }

  @override
  Future<Chat> getChatUser(String userId) async {
    final response = await dio.get('/chats/user/$userId');

    final Chat chat = ChatMapper.chatsJsonToEntity(response.data);
    return chat;
  }
}

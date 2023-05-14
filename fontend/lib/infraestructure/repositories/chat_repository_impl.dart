import 'package:study_sphere_frontend/domain/datasources/chat_datasource.dart';
import 'package:study_sphere_frontend/domain/entity/chat.dart';
import 'package:study_sphere_frontend/domain/entity/chat_message.dart';
import 'package:study_sphere_frontend/domain/repositories/chat_repository.dart';
import 'package:study_sphere_frontend/infraestructure/datasources/chat_datasource_imp.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDatasource datasource;
  ChatRepositoryImpl({ChatDatasource? datasource})
      : datasource = datasource ?? ChatDatasourceImpls();

  @override
  Future<List<Chat>> getChats(String token) {
    return datasource.getChats(token);
  }

  @override
  Future<List<ChatMessage>> getHistorialChat(String token, String messagerId) {
    return datasource.getHistorialChat(token, messagerId);
  }

  @override
  Future<Chat> getChatUser(String userId) {
    return datasource.getChatUser(userId);
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/domain/entity/chat.dart';
import 'package:study_sphere_frontend/domain/entity/chat_message.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/chat_mapper.dart';

void main() {
  group('chat mapper test', () {
    test('chatsJsonToEntity should return Chat object', () {
      final json = {
        'id': "1",
        'name': 'John',
        'surname': 'Doe',
        'email': 'johndoe@example.com',
        'avatar': 'https://example.com/avatar.png'
      };

      final chat = ChatMapper.chatsJsonToEntity(json);

      expect(chat, isInstanceOf<Chat>());
      expect(chat.id, equals("1"));
      expect(chat.name, equals('John'));
      expect(chat.surname, equals('Doe'));
      expect(chat.email, equals('johndoe@example.com'));
      expect(chat.avatar, equals('https://example.com/avatar.png'));
    });
    test('chatMessageJsonToEntity should return ChatMessage object', () {
      final json = {
        'id': "1",
        'senderId': "2",
        'reciberId': "3",
        'content': 'Hello',
        'created_at': '2022-05-14T14:30:00Z',
      };

      final chatMessage = ChatMapper.chatMessageJsonToEntity(json);

      expect(chatMessage, isInstanceOf<ChatMessage>());
      expect(chatMessage.id, equals("1"));
      expect(chatMessage.senderId, equals("2"));
      expect(chatMessage.reciberId, equals("3"));
      expect(chatMessage.content, equals('Hello'));
      expect(chatMessage.createdAt, equals(DateTime.utc(2022, 5, 14, 14, 30)));
    });
    test('should correctly map Chat and ChatMessage objects', () {
      final chatJson = {
        'id': "1",
        'name': 'John',
        'surname': 'Doe',
        'email': 'johndoe@example.com',
        'avatar': 'https://example.com/avatar.png'
      };

      final chatMessageJson = {
        'id': "1",
        'senderId': "2",
        'reciberId': "3",
        'content': 'Hello',
        'created_at': '2022-05-14T14:30:00Z',
      };

      final chat = ChatMapper.chatsJsonToEntity(chatJson);
      final chatMessage = ChatMapper.chatMessageJsonToEntity(chatMessageJson);

      expect(chat, isInstanceOf<Chat>());
      expect(chat.id, equals("1"));
      expect(chat.name, equals('John'));
      expect(chat.surname, equals('Doe'));
      expect(chat.email, equals('johndoe@example.com'));
      expect(chat.avatar, equals('https://example.com/avatar.png'));

      expect(chatMessage, isInstanceOf<ChatMessage>());
      expect(chatMessage.id, equals("1"));
      expect(chatMessage.senderId, equals("2"));
      expect(chatMessage.reciberId, equals("3"));
      expect(chatMessage.content, equals('Hello'));
      expect(chatMessage.createdAt, equals(DateTime.utc(2022, 5, 14, 14, 30)));
    });
  });
}

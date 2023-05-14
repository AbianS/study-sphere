import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/domain/entity/user.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/user_mapper.dart';

void main() {
  group('user mapper test', () {
    test('userEntityToJson() should return a Map<String, dynamic>', () {
      final user = User(
        id: '1',
        email: 'test@test.com',
        name: 'John',
        surname: 'Doe',
        avatar: 'http://example.com/avatar.jpg',
        phone: '+1234567890',
        token: 'token123',
      );

      final userJson = UserMapper.userEntityToJson(user);

      expect(userJson['id'], '1');
      expect(userJson['email'], 'test@test.com');
      expect(userJson['name'], 'John');
      expect(userJson['surname'], 'Doe');
      expect(userJson['phone'], '+1234567890');
      expect(userJson['token'], 'token123');
    });
    test('userJsonToEntity() should return a User object', () {
      final userJson = {
        'id': '1',
        'email': 'test@test.com',
        'name': 'John',
        'surname': 'Doe',
        'avatar': 'http://example.com/avatar.jpg',
        'phone': '+1234567890',
        'token': 'token123',
      };

      final user = UserMapper.userJsonToEntity(userJson);

      expect(user.id, '1');
      expect(user.email, 'test@test.com');
      expect(user.name, 'John');
      expect(user.surname, 'Doe');
      expect(user.avatar, 'http://example.com/avatar.jpg');
      expect(user.phone, '+1234567890');
      expect(user.token, 'token123');
    });

    test('simpleUserJsonToEntity() should return a SimpleUser object', () {
      final simpleUserJson = {
        'name': 'John',
        'email': 'test@test.com',
        'avatar': 'http://example.com/avatar.jpg',
      };

      final simpleUser = UserMapper.simpleUserJsonToEntity(simpleUserJson);

      expect(simpleUser.name, 'John');
      expect(simpleUser.email, 'test@test.com');
      expect(simpleUser.avatar, 'http://example.com/avatar.jpg');
    });
  });
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:study_sphere_frontend/domain/entity/user.dart';
import 'package:study_sphere_frontend/infraestructure/datasources/auth_datasource_impl.dart';

void main() async {
  await dotenv.load();
  Dio dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  const path = 'http://192.168.0.117:8080/auth/login';

  group('login test', () {
    test('sueccessful login', () async {
      final responseJson = {
        "id": "60b59200-4cbe-46c3-952a-ab46fd7057ba",
        "name": "Abian",
        "surname": "Suarez Brito",
        "phone": "608302935",
        "email": "abiansuarezbrito@gmail.com",
        "avatar": null,
        "notifications_token": [
          "d0REUi6eQfalVZO8IX716V:APA91bGouBOlHGHAoveFvArl-SN6lRxgNeQS54jMlqYEUUcZGV7fUpg2dLGfBpPHdT9isJa0Dyb7pDURaM1HCqBzy75eMyXN-oGS7i0qJoVq538IybKq6-gk9iMVJbbY2-8cpSWkhFMA"
        ],
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwYjU5MjAwLTRjYmUtNDZjMy05NTJhLWFiNDZmZDcwNTdiYSIsImlhdCI6MTY4NDA3NTA0MywiZXhwIjoxNjg0MDgyMjQzfQ.UmyfozcAu8jRkQ5VcNK0vaCDUbp76WHbWso4jsW9chw"
      };

      dioAdapter.onPost(path, (server) => server.reply(201, responseJson));

      final User user = await AuthDatasourceImpls().login(
        'abiansuarezbrito@gmail.com',
        '123456Abian',
      );

      expect(user.email, "abiansuarezbrito@gmail.com");
      expect(user.name, 'Abian');
    });
  });

  test('failed login', () async {
    dioAdapter.onPost(path, (server) => server.reply(401, {}));

    expect(() async {
      await AuthDatasourceImpls().login(
        'notExist@gmail.com',
        '123456Abian',
      );
    }, throwsException);
  });
}

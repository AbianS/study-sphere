import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:study_sphere_frontend/domain/dtos/register.dto.dart';
import 'package:study_sphere_frontend/infraestructure/datasources/auth_datasource_impl.dart';

void main() async {
  await dotenv.load();
  Dio dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  const path = 'http://192.168.0.117:8080/auth/login';
  group('register test', () {
    test('bad register, user exist', () async {
      final responseJson = {
        "id": "c116602b-221d-414f-919c-95d26a125865",
        "name": "abian",
        "surname": "suarez",
        "phone": "608302935",
        "email": "abiansuarezbrito@gmail.com",
        "avatar": null,
        "notifications_token": [],
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMxMTY2MDJiLTIyMWQtNDE0Zi05MTljLTk1ZDI2YTEyNTg2NSIsImlhdCI6MTY4NDA3NTc2NywiZXhwIjoxNjg0MDgyOTY3fQ.OBVfksUrDObruPL7LCXQWr4UUrmy88t7N-eA-kpYdR0"
      };

      dioAdapter.onPost(path, (server) => server.reply(201, responseJson));

      final RegisterDTO registerDTO = RegisterDTO(
        name: 'prueba 1',
        surname: 'Prueba Suarez',
        email: 'prueba@gmail.com',
        password: '123456Abian',
        phone: '608301111',
      );

      expect(() async {
        await AuthDatasourceImpls().register(registerDTO);
      }, throwsException);
    });
  });
}

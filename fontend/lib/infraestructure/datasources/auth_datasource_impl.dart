import 'package:dio/dio.dart';
import 'package:study_sphere_frontend/config/constants/enviroment.dart';
import 'package:study_sphere_frontend/domain/datasources/auth_datasource.dart';
import 'package:study_sphere_frontend/domain/dtos/register.dto.dart';
import 'package:study_sphere_frontend/domain/dtos/update_user_dto.dart';
import 'package:study_sphere_frontend/domain/entity/user.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/user_mapper.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

class AuthDatasourceImpls extends AuthDatasource {
  final Dio dio;

  AuthDatasourceImpls({Dio? dio})
      : dio = dio ??
            Dio(BaseOptions(
              baseUrl: Enviroment.api_url,
            ));

  @override
  Future<User> login(String email, String password) async {
    final response = await dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 201) {
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    }

    throw Exception('user not found');
  }

  @override
  Future<User> register(RegisterDTO registerDTO) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        "name": registerDTO.name,
        "surname": registerDTO.surname,
        "email": registerDTO.email,
        "password": registerDTO.password,
        "phone": registerDTO.phone,
      },
    );

    if (response.statusCode == 201) {
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    }

    throw Exception('user can`t create');
  }

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token incorrecto');
      }
      throw Exception('Token incorrecto');
    } catch (e) {
      print(e);
      throw Exception('Token incorrecto');
    }
  }

  @override
  Future<void> createNotificationToken(
      String token, String notificationToken) async {
    final response = await dio.post(
      '/auth/notification/$notificationToken',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return;
  }

  @override
  Future<void> resetPassword(String email) async {
    final response = await dio.post('/auth/restore-password', data: {
      "email": email,
    });

    return;
  }

  @override
  Future<void> checkResetPassword(String email, String code) async {
    final response = await dio.post('/auth/check-restore-password', data: {
      "email": email,
      "code": code,
    });

    return;
  }

  @override
  Future<void> confirmResetPassword(String email, String password) async {
    final response = await dio.post('/auth/confirm-restore-password', data: {
      "email": email,
      "password": password,
    });

    return;
  }

  @override
  Future<User> updateUser(String token, UpdateUserDTO updateUserDTO) async {
    FormData formData = FormData();

    Map<String, dynamic> userMap = updateUserDTO.topMap();
    userMap.removeWhere((key, value) => value == "");

    formData.fields.addAll(
        userMap.entries.map((entry) => MapEntry(entry.key, entry.value)));

    if (updateUserDTO.file != null) {
      formData.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(updateUserDTO.file!.path,
              contentType: Utils.getValidContentType(updateUserDTO.file!.path)),
        ),
      );
    }

    try {
      final response = await dio.patch(
        '/auth/update',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        final user = UserMapper.userJsonToEntity(response.data);
        return user;
      }

      throw Exception('user can`t create');
    } catch (e) {
      throw Exception('user can`t create');
      print(e);
    }
  }
}

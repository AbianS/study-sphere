import 'package:study_sphere_frontend/domain/datasources/auth_datasource.dart';
import 'package:study_sphere_frontend/domain/dtos/register.dto.dart';
import 'package:study_sphere_frontend/domain/dtos/update_user_dto.dart';
import 'package:study_sphere_frontend/domain/entity/user.dart';
import 'package:study_sphere_frontend/domain/repositories/auth_repository.dart';
import 'package:study_sphere_frontend/infraestructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl([AuthDatasource? datasource])
      : datasource = datasource ?? AuthDatasourceImpls();

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<User> register(RegisterDTO registerDTO) {
    return datasource.register(registerDTO);
  }

  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<void> createNotificationToken(String token, String notificationToken) {
    return datasource.createNotificationToken(token, notificationToken);
  }

  @override
  Future<void> resetPassword(String email) {
    return datasource.resetPassword(email);
  }

  @override
  Future<void> checkResetPassword(String email, String code) {
    return datasource.checkResetPassword(email, code);
  }

  @override
  Future<void> confirmResetPassword(String email, String password) {
    return datasource.confirmResetPassword(email, password);
  }

  @override
  Future<User> updateUser(String token, UpdateUserDTO updateUserDTO) {
    return datasource.updateUser(token, updateUserDTO);
  }
}

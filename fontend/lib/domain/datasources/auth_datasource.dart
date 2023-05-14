import 'package:study_sphere_frontend/domain/dtos/register.dto.dart';
import 'package:study_sphere_frontend/domain/dtos/update_user_dto.dart';
import 'package:study_sphere_frontend/domain/entity/user.dart';

abstract class AuthDatasource {
  Future<User> register(RegisterDTO registerDTO);
  Future<User> login(String email, String password);
  Future<User> checkAuthStatus(String token);
  Future<void> createNotificationToken(String token, String notificationToken);
  Future<void> resetPassword(String email);
  Future<void> checkResetPassword(String email, String code);
  Future<void> confirmResetPassword(String email, String password);
  Future<User> updateUser(String token, UpdateUserDTO updateUserDTO);
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/domain/dtos/register.dto.dart';
import 'package:study_sphere_frontend/domain/dtos/update_user_dto.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/user_mapper.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/auth_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/providers/socket_provider.dart';

import '../../domain/entity/user.dart';
import '../../infraestructure/services/secure_storage_service_impl.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
}

enum UpdateUserState {
  chill,
  loading,
  allGood,
  errorPost,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepositoryImpl? repository})
      : repository = repository ?? AuthRepositoryImpl();

  final AuthRepositoryImpl repository;
  final keyValueStorageService = KeyValueStorageServiceImpl();

  AuthStatus _authStatus = AuthStatus.checking;
  User? _user;

  User? get user => _user;
  AuthStatus get authStatus => _authStatus;
  UpdateUserState updateState = UpdateUserState.chill;
  dynamic progressHUD;

  XFile? modifyProfilePicture;

  void saveTempImage(XFile? file) {
    modifyProfilePicture = file;
    notifyListeners();
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final user = await repository.login(email, password);
      await _setLoggedUser(user);
      context.go('/home');
    } catch (e) {
      throw Error();
    }
  }

  Future<void> register({
    required BuildContext context,
    required RegisterDTO registerDTO,
  }) async {
    try {
      final user = await repository.register(registerDTO);
      await _setLoggedUser(user);
      context.go('/home');
    } catch (e) {
      print(e);
    }
  }

  Future<bool> restorePassword({required String email}) async {
    try {
      await repository.resetPassword(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkRestorePassword(
      {required String email, required String code}) async {
    try {
      await repository.checkResetPassword(email, code);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> confirmRestorePassword({
    required String email,
    required String password,
  }) async {
    try {
      await repository.confirmResetPassword(email, password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue(
        'user', jsonEncode(UserMapper.userEntityToJson(user)));
    _authStatus = AuthStatus.authenticated;
    _user = user;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await keyValueStorageService.removeKey('user');
    _authStatus = AuthStatus.notAuthenticated;
    _user = null;
    context.go('/login');
    notifyListeners();
  }

  Future<void> logoutWithOutNav() async {
    await keyValueStorageService.removeKey('user');
    _authStatus = AuthStatus.notAuthenticated;
    _user = null;

    notifyListeners();
  }

  Future<bool> isTheFirstTime(BuildContext context) async {
    final isTheFirstTime =
        await keyValueStorageService.getValue<int>('isTheFirstTime');

    if (isTheFirstTime == null) {
      await keyValueStorageService.setKeyValue('isTheFirstTime', 1);
      return true;
    }

    return false;
  }

  Future<void> checkStatus(BuildContext context) async {
    final userSaved = await keyValueStorageService.getValue<String>('user');
    if (userSaved == null) return logoutWithOutNav();

    try {
      final User userSession =
          UserMapper.userJsonToEntity(jsonDecode(userSaved));
      final user = await repository.checkAuthStatus(userSession.token);
      _setLoggedUser(user);
    } catch (e) {
      await logoutWithOutNav();
    }
  }

  Future<void> updateUser(UpdateUserDTO updateUserDTO) async {
    progressHUD.showWithText('Actualizando Usuario...');
    if (modifyProfilePicture != null) {
      File file = File.fromUri(Uri.parse(modifyProfilePicture!.path));
      updateUserDTO.file = file;
    }

    updateState = UpdateUserState.loading;
    notifyListeners();

    try {
      final userUpdated =
          await repository.updateUser(user?.token ?? "", updateUserDTO);
      _setLoggedUser(userUpdated);
      updateState = UpdateUserState.allGood;
      notifyListeners();
      progressHUD.dismiss();
      _showToast();
    } catch (e) {
      updateState = UpdateUserState.errorPost;
      notifyListeners();
      print(e);
    }
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Usuario Actualizado",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}

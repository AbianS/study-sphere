import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/infraestructure/errors/errors.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/code.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/providers/home_provider.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

enum JoinStatus {
  invalid,
  valid,
  validating,
  posting,
  writting,
  teacherError,
  notExistErro,
  allGood,
}

class JoinClassProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;
  final HomeProvider homeProvider;

  JoinClassProvider(this.homeProvider, {ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  JoinStatus _joinStatus = JoinStatus.invalid;
  Code _code = const Code.pure();
  bool _isValid = false;
  dynamic progressHUD;

  // getters
  Code get code => _code;
  JoinStatus get joinStatus => _joinStatus;
  bool get isValid => _isValid;

  void codeChange(String value) {
    _code = Code.dirty(value);
    _joinStatus = JoinStatus.writting;
    _isValid = Formz.validate([_code]);
    notifyListeners();
  }

  void submit(BuildContext context, String token) async {
    if (!_isValid) {
      _code = Code.dirty(_code.value);
      notifyListeners();
    } else {
      await join(token, context);

      if (defaultTargetPlatform == TargetPlatform.windows) {
        context.pop();
      }
    }
  }

  Future<void> join(String token, BuildContext context) async {
    try {
      progressHUD.showWithText('Uniendose a la Clase...');
      _joinStatus = JoinStatus.posting;
      notifyListeners();
      await repository.joinClass(token, _code.value);
      await homeProvider.getClases(token);
      progressHUD.dismiss();
      if (defaultTargetPlatform == TargetPlatform.android) {
        Utils.showToast("Te has Unido a la clase!!");
      }
      _code = const Code.pure();
      _joinStatus = JoinStatus.allGood;
      notifyListeners();
    } on TeacherError {
      progressHUD.dismiss();
      _joinStatus = JoinStatus.teacherError;
      _isValid = false;
      notifyListeners();
    } on NotFoundClass {
      progressHUD.dismiss();
      _joinStatus = JoinStatus.notExistErro;
      _isValid = false;
      notifyListeners();
    } catch (e) {
      progressHUD.dismiss();
      print(e);
    }
  }
}

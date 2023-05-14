import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_sphere_frontend/domain/dtos/create_class_dto.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/home_provider.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

enum CreateStatus {
  invalid,
  valid,
  checking,
  writting,
  posting,
  allGood,
}

class CreateClassProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;

  final AuthProvider authProvider;
  final HomeProvider homeProvider;

  CreateClassProvider(this.authProvider, this.homeProvider,
      {ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  String _title = '';
  String _description = '';
  bool _isValid = false;
  CreateStatus _createStatus = CreateStatus.invalid;
  dynamic progressHUD;

  String get title => _title;
  String get description => _description;
  bool get isValid => _isValid;
  CreateStatus get createStatus => _createStatus;

  void changeTitle(String newValue) {
    _title = newValue;
    _createStatus = CreateStatus.writting;
    _isValid = (newValue.length >= 6);
    notifyListeners();
  }

  void changeDescription(String newValue) {
    _description = newValue;
    notifyListeners();
  }

  void submit(BuildContext context, String token) async {
    progressHUD.showWithText('Creando Clase...');
    CreateClassDTO createClassDTO = CreateClassDTO(
      token: authProvider.user!.token,
      title: _title,
      description: _description,
    );
    await repository.createClass(createClassDTO);
    await homeProvider.getClases(authProvider.user!.token);

    progressHUD.dismiss();
    if (defaultTargetPlatform == TargetPlatform.android) {
      Utils.showToast("La clase se ha creado correctamente");
    }
  }
}

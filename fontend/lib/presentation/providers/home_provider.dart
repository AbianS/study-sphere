import 'package:flutter/material.dart';
import 'package:study_sphere_frontend/domain/entity/simple_class.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';

enum HomeStatus {
  loading,
  loaded,
  failLoaded,
}

class HomeProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;
  HomeProvider({ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  HomeStatus _homeStatus = HomeStatus.loading;
  List<SimpleClase>? _clases;
  bool _showDivider = false;

  HomeStatus get homeStatus => _homeStatus;
  List<SimpleClase>? get clases => _clases;
  bool get showDivider => _showDivider;

  set showDivider(bool newValue) {
    _showDivider = newValue;
  }

  Future<void> getClases(String token) async {
    try {
      _homeStatus = HomeStatus.loading;
      notifyListeners();
      final clases = await repository.getAllMyClass(token);
      _homeStatus = HomeStatus.loaded;
      _clases = clases;
      notifyListeners();
    } catch (e) {
      _homeStatus = HomeStatus.failLoaded;
      _clases = [];
      notifyListeners();
    }
  }
}

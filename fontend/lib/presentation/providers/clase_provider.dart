import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_sphere_frontend/domain/dtos/create_annotation.dart';
import 'package:study_sphere_frontend/domain/dtos/create_comment.dart';
import 'package:study_sphere_frontend/domain/entity/detail_class.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

enum ClaseStatus {
  checking,
  getClass,
  errorClass,
}

class ClaseProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;
  ClaseProvider({ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  DetailClass? _clase;
  ClaseStatus _claseStatus = ClaseStatus.checking;
  int _currentIndex = 0;

  DetailClass? get clase => _clase;
  ClaseStatus get claseStatus => _claseStatus;
  int get currentIndex => _currentIndex;

  Future<void> getClaseById(String token, String id) async {
    try {
      _claseStatus = ClaseStatus.checking;
      notifyListeners();
      final detailClass = await repository.getClassById(token, id);
      _clase = detailClass;
      _claseStatus = ClaseStatus.getClass;
      print(_clase);
      notifyListeners();
    } catch (e) {
      print(e);
      _claseStatus = ClaseStatus.errorClass;
      notifyListeners();
    }
  }

  Future<void> createComment(
      String token, CreateCommentDTO createCommentDTO) async {
    try {
      await repository.createComment(token, createCommentDTO);

      await getClaseById(token, createCommentDTO.classID);
      Utils.showToast("Comentario Creado correctamente");
    } catch (e) {}
  }

  Future<void> createAnnotation(
    String token,
    CreateAnnotationDTO createAnnotationDTO,
  ) async {
    try {
      await repository.createAnnotation(token, createAnnotationDTO);
      Utils.showToast('Comentario Creado correctamente');
    } catch (e) {
      Utils.showToast('Ha habido un error al crear el comentaro');
    }
  }

  void changeCurrentIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:study_sphere_frontend/domain/dtos/correct_class_dto.dart';
import 'package:study_sphere_frontend/domain/entity/complete_task_user.dart';

import '../../infraestructure/repositories/clase_repository_impl.dart';

enum TeacherStatus { allGood, errorPost, loading }

class TeacherProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;
  TeacherProvider({ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  List<CompleteTaskUser> completeTask = [];
  TeacherStatus status = TeacherStatus.loading;

  int get completedTask => completeTask.where((task) => task.completed).length;
  int get gradeTask => completeTask.where((task) => task.grade != null).length;

  void getData(String token, String taskId) async {
    try {
      completeTask = await repository.getAllTaskUser(token, taskId);
      status = TeacherStatus.allGood;
      notifyListeners();
    } catch (e) {
      print(e);
      status = TeacherStatus.errorPost;
      notifyListeners();
    }
  }

  void correctTask(String token, CorrectTaskDTO correctTaskDTO) async {
    await repository.correctTask(token, correctTaskDTO);
  }
}

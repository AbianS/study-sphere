import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_sphere_frontend/domain/entity/task.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';

enum TaskStatus {
  loading,
  allGod,
  errorPost,
}

enum TaskSolverStatus { chill, loading, allGood, errorPost }

class TaskProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;

  TaskProvider({ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  Task? _task = null;
  List<File> files = [];
  TaskStatus _status = TaskStatus.loading;
  TaskSolverStatus solveStatus = TaskSolverStatus.chill;
  dynamic progressHUD;

  Task? get task => _task;
  TaskStatus get status => _status;

  Future<void> getTaskById(String token, String taskId) async {
    try {
      final taskRes = await repository.getTaskById(taskId, token);
      _task = taskRes;
      _status = TaskStatus.allGod;
      notifyListeners();
    } catch (e) {
      _status = TaskStatus.errorPost;
      notifyListeners();
    }
  }

  void upadateFiles(List<File> newFiles) {
    files.addAll(newFiles);
    notifyListeners();
  }

  Future<void> solveTask(String token) async {
    try {
      progressHUD.showWithText('Subiendo Tarea...');
      solveStatus = TaskSolverStatus.loading;
      notifyListeners();
      await repository.newSolveTask(task!.id, token, files);
      progressHUD.dismiss();
      solveStatus = TaskSolverStatus.allGood;
      notifyListeners();
      _showToast();
    } catch (e) {
      solveStatus = TaskSolverStatus.errorPost;
      notifyListeners();
    }
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "La Tarea se entrego correctamente",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}

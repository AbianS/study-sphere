import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/providers/task_provider.dart';

enum TaskSolveStatus {
  chill,
  posting,
  errorPost,
  allGood,
}

class SolveTaskProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;

  SolveTaskProvider({ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  String _answer = "";
  TaskSolveStatus _status = TaskSolveStatus.chill;

  String get answer => _answer;
  TaskSolveStatus get status => _status;

  void changestatus(TaskSolveStatus newStatus) {
    _status = newStatus;
  }

  void changeAnswerValue(String? newValue) {
    print(newValue);
    _answer = newValue ?? _answer;
    notifyListeners();
  }

  void submit(String taskId, String token, BuildContext context,
      TaskProvider taskProvider) async {
    _status = TaskSolveStatus.posting;
    notifyListeners();
    try {
      await repository.solveTask(taskId, token, answer);
      _status = TaskSolveStatus.allGood;
      await taskProvider.getTaskById(token, taskId);
      notifyListeners();
      _showToast(context);
    } catch (e) {
      _status = TaskSolveStatus.errorPost;
      notifyListeners();
      print(e);
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('La Tarea se ha subido correctamente'),
        action: SnackBarAction(
          label: 'Ir a la tarea',
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}

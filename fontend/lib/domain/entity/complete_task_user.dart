import 'package:study_sphere_frontend/domain/entity/simple_task.dart';
import 'package:study_sphere_frontend/domain/entity/user_task.dart';

class CompleteTaskUser {
  final int id;
  final SimpleTasK task;
  final UserTask user;
  final List<String> files;
  final int? grade;
  final bool completed;

  CompleteTaskUser({
    required this.id,
    required this.task,
    required this.user,
    required this.completed,
    required this.files,
    this.grade,
  });
}

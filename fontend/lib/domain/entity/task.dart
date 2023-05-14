import 'package:study_sphere_frontend/domain/entity/annotation.dart';
import 'package:study_sphere_frontend/domain/entity/task_user.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String topicId;
  final int? score;
  final List<String> files;
  final String claseId;
  final List<Annotation> annotations;
  final List<TaskUser> taskUser;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.topicId,
    required this.annotations,
    required this.score,
    required this.claseId,
    required this.files,
    required this.taskUser,
    required this.createdAt,
  });
}

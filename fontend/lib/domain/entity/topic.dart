import 'package:study_sphere_frontend/domain/entity/material.dart';
import 'package:study_sphere_frontend/domain/entity/question.dart';
import 'package:study_sphere_frontend/domain/entity/task.dart';

class Topic {
  final String id;
  final String title;
  final List<MaterialEntity> material;
  final List<Question> question;
  final List<Task> task;

  Topic({
    required this.id,
    required this.title,
    required this.material,
    required this.question,
    required this.task,
  });
}

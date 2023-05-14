import 'package:study_sphere_frontend/domain/entity/comment.dart';
import 'package:study_sphere_frontend/domain/entity/simple_user.dart';
import 'package:study_sphere_frontend/domain/entity/topic.dart';

class DetailClass {
  final String id;
  final String title;
  final String description;
  final List<SimpleUser> students;
  final List<Comment> comments;
  final SimpleUser teacher;
  final List<Topic> topic;
  final String bg;
  final String role;

  DetailClass({
    required this.id,
    required this.title,
    required this.bg,
    required this.description,
    required this.students,
    required this.teacher,
    required this.topic,
    required this.role,
    required this.comments,
  });
}

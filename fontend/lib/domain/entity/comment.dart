import 'package:study_sphere_frontend/domain/entity/annotation.dart';
import 'package:study_sphere_frontend/domain/entity/simple_user.dart';

class Comment {
  final String id;
  final String text;
  final SimpleUser user;
  final DateTime createdAt;
  final List<String> files;
  final List<Annotation> annotations;
  final DateTime UpdatedAt;

  Comment({
    required this.id,
    required this.text,
    required this.user,
    required this.files,
    required this.annotations,
    required this.createdAt,
    required this.UpdatedAt,
  });
}

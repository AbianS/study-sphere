import 'package:study_sphere_frontend/domain/entity/annotation.dart';

class MaterialEntity {
  final String id;
  final String title;
  final String? description;
  final List<String> files;
  final List<Annotation> annotations;
  final String topicId;
  final String claseId;
  final DateTime createdAt;

  MaterialEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.files,
    required this.annotations,
    required this.topicId,
    required this.claseId,
    required this.createdAt,
  });
}

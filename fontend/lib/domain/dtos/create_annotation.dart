import 'package:study_sphere_frontend/presentation/screens/annotation/annotation_screen.dart';

class CreateAnnotationDTO {
  final String id;
  final String text;
  final AnnotationType type;

  CreateAnnotationDTO({
    required this.id,
    required this.text,
    required this.type,
  });
}

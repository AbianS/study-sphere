import 'package:study_sphere_frontend/domain/entity/annotation.dart';
import 'package:study_sphere_frontend/domain/entity/question_user.dart';

class Question {
  final String id;
  final String question;
  final int? score;
  final String topicId;
  final DateTime? dueDate;
  final List<Annotation> annotations;
  final List<QuestionUser> questionUser;
  final DateTime createdAt;

  Question({
    required this.id,
    required this.question,
    required this.score,
    required this.dueDate,
    required this.annotations,
    required this.topicId,
    required this.questionUser,
    required this.createdAt,
  });
}

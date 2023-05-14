import 'package:study_sphere_frontend/domain/entity/annotation.dart';
import 'package:study_sphere_frontend/domain/entity/comment.dart';
import 'package:study_sphere_frontend/domain/entity/complete_task_user.dart';
import 'package:study_sphere_frontend/domain/entity/detail_class.dart';
import 'package:study_sphere_frontend/domain/entity/material.dart';
import 'package:study_sphere_frontend/domain/entity/question.dart';
import 'package:study_sphere_frontend/domain/entity/question_user.dart';
import 'package:study_sphere_frontend/domain/entity/simple_class.dart';
import 'package:study_sphere_frontend/domain/entity/simple_task.dart';
import 'package:study_sphere_frontend/domain/entity/simple_topic.dart';
import 'package:study_sphere_frontend/domain/entity/simple_user.dart';
import 'package:study_sphere_frontend/domain/entity/task.dart';
import 'package:study_sphere_frontend/domain/entity/task_user.dart';
import 'package:study_sphere_frontend/domain/entity/topic.dart';
import 'package:study_sphere_frontend/domain/entity/user_task.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/user_mapper.dart';

class ClaseMapper {
  static SimpleClase simpleClaseJsonToEntity(Map<String, dynamic> json) =>
      SimpleClase(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        students: json['students'],
        teacherName: json['teacherName'],
        bg: json['bg'],
      );

  static DetailClass detailClassJsonToEntity(Map<String, dynamic> json) =>
      DetailClass(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        students: List<SimpleUser>.from(
          json['students'].map((x) => UserMapper.simpleUserJsonToEntity(x)),
        ),
        teacher: UserMapper.simpleUserJsonToEntity(json['teacher']),
        role: json['role'],
        comments: List<Comment>.from(
          json['comments'].map(
            (x) => ClaseMapper.commentClassJsonToEntity(x),
          ),
        ),
        topic: List<Topic>.from(
          json['topic'].map(
            (x) => ClaseMapper.topicClassJsonToEntity(x),
          ),
        ),
        bg: json['bg'],
      );

  static Comment commentClassJsonToEntity(Map<String, dynamic> json) => Comment(
        id: json['id'],
        text: json['text'],
        user: UserMapper.simpleUserOnlyNameJsonToEntity(json['user']),
        createdAt: DateTime.parse(json['created_at']),
        annotations: List<Annotation>.from(
          json['annotations'].map(
            (x) => ClaseMapper.annotationJsonToEntity(x),
          ),
        ),
        files: List<String>.from(json['files']),
        UpdatedAt: DateTime.parse(json['updated_at']),
      );

  static Topic topicClassJsonToEntity(Map<String, dynamic> json) => Topic(
        id: json['id'],
        title: json['title'],
        material: List<MaterialEntity>.from(
          json['Material'].map(
            (x) => ClaseMapper.materialJsonToEntity(x),
          ),
        ),
        question: List<Question>.from(
          json['Question'].map(
            (x) => ClaseMapper.questionJsonEntity(x),
          ),
        ),
        task: List<Task>.from(
          json['Task'].map(
            (x) => ClaseMapper.taskJsonEntity(x),
          ),
        ),
      );

  static MaterialEntity materialJsonToEntity(Map<String, dynamic> json) =>
      MaterialEntity(
        id: json['id'],
        title: json['title'],
        claseId: json['claseId'],
        files: List<String>.from(json['files']),
        annotations: List<Annotation>.from(
          json['annotations'].map(
            (x) => ClaseMapper.annotationJsonToEntity(x),
          ),
        ),
        description: json['description'],
        topicId: json['topicId'],
        createdAt: DateTime.parse(json['created_at']),
      );

  static Question questionJsonEntity(Map<String, dynamic> json) => Question(
        id: json['id'],
        question: json['question'],
        score: json['score'],
        topicId: json['topicId'],
        annotations: List<Annotation>.from(
          json['annotations'].map(
            (x) => ClaseMapper.annotationJsonToEntity(x),
          ),
        ),
        questionUser: List<QuestionUser>.from(
          json['QuestionUser'].map(
            (x) => ClaseMapper.questionUserJsonToEntity(x),
          ),
        ),
        createdAt: DateTime.parse(json['created_at']),
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      );

  static Task taskJsonEntity(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        score: json['score'],
        claseId: json['claseId'],
        topicId: json['topicId'],
        annotations: List<Annotation>.from(
          json['annotations'].map(
            (x) => ClaseMapper.annotationJsonToEntity(x),
          ),
        ),
        files: List<String>.from(json['files'].map((x) => x)),
        createdAt: DateTime.parse(json['created_at']),
        taskUser: List<TaskUser>.from(
          json['TaskUser'].map(
            (x) => ClaseMapper.taskUserJsonToEntity(x),
          ),
        ),
      );

  static TaskUser taskUserJsonToEntity(Map<String, dynamic> json) => TaskUser(
        completed: json['completed'],
        files: List<String>.from(json['files'].map((x) => x)),
      );

  static QuestionUser questionUserJsonToEntity(Map<String, dynamic> json) =>
      QuestionUser(
        completed: json['completed'],
      );

  static SimpleTopic simpleTopicJsonToEntity(Map<String, dynamic> json) =>
      SimpleTopic(
        id: json['id'],
        title: json['title'],
      );

  static UserTask userTaskJsonToEntity(Map<String, dynamic> json) => UserTask(
        id: json['id'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        avatar: json['avatar'],
      );

  static SimpleTasK simpleTaskJsonToEntity(Map<String, dynamic> json) =>
      SimpleTasK(
        id: json['id'],
        title: json['title'],
        score: json['score'],
        description: json['description'],
      );

  static CompleteTaskUser completeTaskUserJsonToEntity(
          Map<String, dynamic> json) =>
      CompleteTaskUser(
        id: json['id'],
        task: simpleTaskJsonToEntity(json['task']),
        user: userTaskJsonToEntity(json['user']),
        files: List<String>.from(json['files'].map((e) => e)),
        grade: json['grade'],
        completed: json['completed'],
      );

  static Annotation annotationJsonToEntity(Map<String, dynamic> json) =>
      Annotation(
        id: json['id'],
        text: json['text'],
        createdAt: DateTime.parse(json['created_at']),
        user: annotationUserJsonToEntity(json['user']),
      );

  static AnnotationUser annotationUserJsonToEntity(Map<String, dynamic> json) =>
      AnnotationUser(
        name: json['name'],
        avatar: json['avatar'],
      );
}

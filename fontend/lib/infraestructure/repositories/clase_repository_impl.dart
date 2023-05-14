import 'dart:io';

import 'package:study_sphere_frontend/domain/datasources/clase_datasource.dart';
import 'package:study_sphere_frontend/domain/dtos/correct_class_dto.dart';
import 'package:study_sphere_frontend/domain/dtos/create_annotation.dart';
import 'package:study_sphere_frontend/domain/dtos/create_class_dto.dart';
import 'package:study_sphere_frontend/domain/dtos/create_comment.dart';
import 'package:study_sphere_frontend/domain/dtos/create_material.dart';
import 'package:study_sphere_frontend/domain/dtos/create_task.dto.dart';
import 'package:study_sphere_frontend/domain/dtos/create_topic_dto.dart';
import 'package:study_sphere_frontend/domain/entity/complete_task_user.dart';
import 'package:study_sphere_frontend/domain/entity/detail_class.dart';
import 'package:study_sphere_frontend/domain/entity/simple_class.dart';
import 'package:study_sphere_frontend/domain/entity/simple_topic.dart';
import 'package:study_sphere_frontend/domain/entity/task.dart';
import 'package:study_sphere_frontend/domain/repositories/clase_repository.dart';
import 'package:study_sphere_frontend/infraestructure/datasources/clase_datasource_impl.dart';

class ClaseRepositoryImpl extends ClaseRepository {
  final ClaseDatasource datasource;
  ClaseRepositoryImpl({ClaseDatasource? datasource})
      : datasource = datasource ?? ClaseDatasourceImpl();

  @override
  Future<List<SimpleClase>> getAllMyClass(String token) {
    return datasource.getAllMyClass(token);
  }

  @override
  Future<void> createClass(CreateClassDTO createClassDTO) {
    return datasource.createClass(createClassDTO);
  }

  @override
  Future<void> joinClass(String token, String code) {
    return datasource.joinClass(token, code);
  }

  @override
  Future<DetailClass> getClassById(String token, String id) {
    return datasource.getClassById(token, id);
  }

  @override
  Future<void> createTopic(CreateTopicDTO createTopicDTO) {
    return datasource.createTopic(createTopicDTO);
  }

  @override
  Future<void> solveTask(String taskId, String token, String answer) {
    return datasource.solveTask(taskId, token, answer);
  }

  @override
  Future<Task> getTaskById(String taskId, String token) {
    return datasource.getTaskById(taskId, token);
  }

  @override
  Future<void> newSolveTask(String taskId, String token, List<File> files) {
    return datasource.newSolveTask(taskId, token, files);
  }

  @override
  Future<List<SimpleTopic>> getAllTopics(String token, String classId) {
    return datasource.getAllTopics(token, classId);
  }

  @override
  Future<void> createTask(String token, CreateTaskDTO createTaskDTO) {
    return datasource.createTask(token, createTaskDTO);
  }

  @override
  Future<List<CompleteTaskUser>> getAllTaskUser(String token, String taskId) {
    return datasource.getAllTaskUser(token, taskId);
  }

  @override
  Future<void> correctTask(String token, CorrectTaskDTO correctTaskDTO) {
    return datasource.correctTask(token, correctTaskDTO);
  }

  @override
  Future<void> createMaterial(
      String token, CreateMaterialDTO createMaterialDTO) {
    return datasource.createMaterial(token, createMaterialDTO);
  }

  @override
  Future<void> createComment(String token, CreateCommentDTO createCommentDTO) {
    return datasource.createComment(token, createCommentDTO);
  }

  @override
  Future<void> createAnnotation(
      String token, CreateAnnotationDTO createAnnotationDTO) {
    return datasource.createAnnotation(token, createAnnotationDTO);
  }
}

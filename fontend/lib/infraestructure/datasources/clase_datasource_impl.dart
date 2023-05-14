import 'dart:io';

import 'package:dio/dio.dart';
import 'package:study_sphere_frontend/config/constants/enviroment.dart';
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
import 'package:study_sphere_frontend/infraestructure/errors/errors.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/clase_mapper.dart';
import 'package:http_parser/http_parser.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

class ClaseDatasourceImpl extends ClaseDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.api_url,
    ),
  );

  @override
  Future<List<SimpleClase>> getAllMyClass(String token) async {
    //TODO: Errores
    final response = await dio.get<List>(
      '/clases',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    final List<SimpleClase> clases = [];
    for (final clase in response.data ?? []) {
      clases.add(ClaseMapper.simpleClaseJsonToEntity(clase));
    }
    return clases;
  }

  @override
  Future<void> createClass(CreateClassDTO createClassDTO) async {
    final response = await dio.post(
      '/clases/create',
      options: Options(
        headers: {'Authorization': 'Bearer ${createClassDTO.token}'},
      ),
      data: {
        "title": createClassDTO.title,
        "description": createClassDTO.description,
      },
    );

    return;
  }

  @override
  Future<void> joinClass(String token, String code) async {
    try {
      await dio.post(
        '/clases/join',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'classId': code,
        },
      );

      return;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) throw NotFoundClass();
      if (e.response!.statusCode == 400) throw TeacherError();

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<DetailClass> getClassById(String token, String id) async {
    try {
      final response = await dio.get(
        '/clases/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final DetailClass clase =
          ClaseMapper.detailClassJsonToEntity(response.data);
      return clase;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> createTopic(CreateTopicDTO createTopicDTO) async {
    try {
      await dio.post(
        '/clases/topic',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${createTopicDTO.token}',
          },
        ),
        data: {
          "title": createTopicDTO.title,
          "claseId": createTopicDTO.claseId,
        },
      );

      return;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) throw NotFoundClass();
      if (e.response!.statusCode == 400) throw TeacherError();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> solveTask(String taskId, String token, String answer) async {
    try {
      await dio.post(
        '/clases/task/$taskId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          'answer': answer,
        },
      );
    } on DioError catch (e) {
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<Task> getTaskById(String taskId, String token) async {
    try {
      final response = await dio.get(
        '/clases/task/$taskId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final Task task = ClaseMapper.taskJsonEntity(response.data);
      return task;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> newSolveTask(
      String taskId, String token, List<File> files) async {
    FormData formData = FormData();
    for (File file in files) {
      formData.files.add(
        MapEntry(
          "files",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: Utils.getValidContentType(file.path),
          ),
        ),
      );
    }

    try {
      final response = await dio.post(
        '/clases/task/$taskId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data'
          },
        ),
        data: formData,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<SimpleTopic>> getAllTopics(String token, String classId) async {
    try {
      final response = await dio.get(
        '/clases/topics/$classId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List<SimpleTopic> topics = [];
      for (final topic in response.data ?? []) {
        topics.add(ClaseMapper.simpleTopicJsonToEntity(topic));
      }
      return topics;
    } catch (e) {
      throw Error();
    }
  }

  @override
  Future<void> createTask(String token, CreateTaskDTO createTaskDTO) async {
    final dueDate = DateTime.utc(
      createTaskDTO.date!.year,
      createTaskDTO.date!.month,
      createTaskDTO.date!.day,
      createTaskDTO.date!.hour,
      createTaskDTO.date!.minute,
    );
    FormData formData = FormData();

    formData.fields.addAll([
      ...createTaskDTO.toMap().entries.map(
            (e) => MapEntry(
              e.key,
              e.value.toString(),
            ),
          )
    ]);
    if (createTaskDTO.files != null && createTaskDTO.files!.isNotEmpty) {
      for (File file in createTaskDTO.files!) {
        formData.files.add(
          MapEntry(
            "files",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: Utils.getValidContentType(file.path),
            ),
          ),
        );
      }
    }

    try {
      final response = await dio.post(
        '/clases/task',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data'
          },
        ),
        data: formData,
      );
      print(response);
      return;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<CompleteTaskUser>> getAllTaskUser(
      String token, String taskId) async {
    final response = await dio.get<List>(
      '/clases/taskUser/$taskId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List<CompleteTaskUser> completeTasks = [];
    for (final taskUser in response.data ?? []) {
      completeTasks.add(ClaseMapper.completeTaskUserJsonToEntity(taskUser));
    }

    return completeTasks;
  }

  @override
  Future<void> correctTask(String token, CorrectTaskDTO correctTaskDTO) async {
    try {
      final response = await dio.post(
        '/clases/task/correct',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          "userId": correctTaskDTO.userId,
          "taskId": correctTaskDTO.taskId,
          "grade": correctTaskDTO.grade,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> createMaterial(
      String token, CreateMaterialDTO createMaterialDTO) async {
    FormData formData = FormData();

    formData.fields.addAll([
      ...createMaterialDTO.toMap().entries.map(
            (e) => MapEntry(
              e.key,
              e.value.toString(),
            ),
          )
    ]);
    if (createMaterialDTO.files != null &&
        createMaterialDTO.files!.isNotEmpty) {
      for (File file in createMaterialDTO.files!) {
        formData.files.add(
          MapEntry(
            "files",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: Utils.getValidContentType(file.path),
            ),
          ),
        );
      }
    }

    try {
      final response = await dio.post(
        '/clases/material',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data'
          },
        ),
        data: formData,
      );
      print(response);
      return;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> createComment(
      String token, CreateCommentDTO createCommentDTO) async {
    FormData formData = FormData();

    formData.fields.addAll([
      ...createCommentDTO.toMap().entries.map(
            (e) => MapEntry(
              e.key,
              e.value.toString(),
            ),
          )
    ]);
    if (createCommentDTO.files != null && createCommentDTO.files!.isNotEmpty) {
      for (File file in createCommentDTO.files!) {
        formData.files.add(
          MapEntry(
            "files",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: Utils.getValidContentType(file.path),
            ),
          ),
        );
      }
    }

    try {
      final response = await dio.post(
        '/clases/comment',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      print(response);

      return;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> createAnnotation(
      String token, CreateAnnotationDTO createAnnotationDTO) async {
    try {
      final response = await dio.post(
        '/clases/annotation',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'id': createAnnotationDTO.id,
          'type': createAnnotationDTO.type.name,
          'text': createAnnotationDTO.text,
        },
      );
      return;
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}

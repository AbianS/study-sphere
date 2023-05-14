import 'package:dio/dio.dart';
import 'package:study_sphere_frontend/config/constants/enviroment.dart';
import 'package:study_sphere_frontend/domain/datasources/todo_datasource.dart';
import 'package:study_sphere_frontend/domain/dtos/create_todo_dto.dart';
import 'package:study_sphere_frontend/domain/entity/todo.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/todo_mapper.dart';

class TodoDatasourceImpl extends TodoDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.api_url,
    ),
  );

  @override
  Future<List<Todo>> getAllTodos(String token) async {
    final response = await dio.get<List>(
      '/todos',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List<Todo> todos = [];
    for (final todo in response.data ?? []) {
      todos.add(TodoMapper.todoJsonToEntity(todo));
    }

    return todos;
  }

  @override
  Future<void> deleteTodo(String token, String id) async {
    final response = await dio.delete(
      '/todos/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return;
  }

  @override
  Future<void> createTodo(String token, CreateTodoDTO todo) async {
    try {
      final response = await dio.post(
        '/todos',
        data: {
          'title': todo.title,
          'execute_day': todo.executeDay.toIso8601String(),
          'notification_time': todo.notificationTime.toIso8601String(),
          'event_day': todo.eventDay.toIso8601String(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response);
    } catch (e) {
      print(e);
    }

    return;
  }
}

import 'package:study_sphere_frontend/domain/datasources/todo_datasource.dart';
import 'package:study_sphere_frontend/domain/dtos/create_todo_dto.dart';
import 'package:study_sphere_frontend/domain/entity/todo.dart';
import 'package:study_sphere_frontend/domain/repositories/todo_repository.dart';
import 'package:study_sphere_frontend/infraestructure/datasources/todo_datasource_impl.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoDatasource datasource;

  TodoRepositoryImpl({TodoDatasource? datasource})
      : datasource = datasource ?? TodoDatasourceImpl();

  @override
  Future<List<Todo>> getAllTodos(String token) {
    return datasource.getAllTodos(token);
  }

  @override
  Future<void> deleteTodo(String token, String id) {
    return datasource.deleteTodo(token, id);
  }

  @override
  Future<void> createTodo(String token, CreateTodoDTO todo) {
    return datasource.createTodo(token, todo);
  }
}

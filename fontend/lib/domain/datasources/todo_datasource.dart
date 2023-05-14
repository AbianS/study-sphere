import 'package:study_sphere_frontend/domain/dtos/create_todo_dto.dart';
import 'package:study_sphere_frontend/domain/entity/todo.dart';

abstract class TodoDatasource {
  Future<List<Todo>> getAllTodos(String token);
  Future<void> deleteTodo(String token, String id);
  Future<void> createTodo(String token, CreateTodoDTO todo);
}

import '../dtos/create_todo_dto.dart';
import '../entity/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAllTodos(String token);
  Future<void> deleteTodo(String token, String id);
  Future<void> createTodo(String token, CreateTodoDTO todo);
}

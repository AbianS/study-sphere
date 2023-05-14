import 'package:flutter/material.dart';
import 'package:study_sphere_frontend/domain/entity/todo.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/todo_repository_impl.dart';
import 'package:table_calendar/table_calendar.dart';

enum TodoStatus { loading, allGood, error }

class TodoProvider extends ChangeNotifier {
  final TodoRepositoryImpl repository;

  TodoProvider({TodoRepositoryImpl? repository})
      : repository = repository ?? TodoRepositoryImpl();

  DateTime markedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  TodoStatus status = TodoStatus.loading;

  List<Todo> todos = [];
  List<Todo> currentTodos = [];
  CalendarFormat calendarFormat = CalendarFormat.week;

  void init(String token) async {
    await getTodos(token);
    getCurrentTodos(markedDay);

    notifyListeners();
  }

  void changeMarkedDay(DateTime selectedTime, DateTime focusedDay) {
    markedDay = selectedTime;
    notifyListeners();
    getCurrentTodos(selectedTime);
  }

  Future<void> getTodos(String token) async {
    status = TodoStatus.loading;
    notifyListeners();
    try {
      final todosList = await repository.getAllTodos(token);
      status = TodoStatus.allGood;
      todos = todosList;
      notifyListeners();
    } catch (e) {
      status = TodoStatus.error;
      notifyListeners();
    }
  }

  void changeCalendarFormat() {
    if (calendarFormat == CalendarFormat.week) {
      calendarFormat = CalendarFormat.twoWeeks;
      notifyListeners();
      return;
    }

    if (calendarFormat == CalendarFormat.twoWeeks) {
      calendarFormat = CalendarFormat.month;
      notifyListeners();
      return;
    }

    if (calendarFormat == CalendarFormat.month) {
      calendarFormat = CalendarFormat.week;
      notifyListeners();
      return;
    }
  }

  List<Todo> loadEvents(DateTime date) {
    return todos.where((todo) => todo.eventDay == date).toList();
  }

  void getCurrentTodos(DateTime date) {
    final filteredTodos = todos.where((todo) => todo.eventDay == date).toList();

    // order by not completed first
    filteredTodos.sort((a, b) => a.completed == b.completed
        ? 0
        : a.completed
            ? 1
            : -1);
    currentTodos = filteredTodos;
    notifyListeners();
  }

  void dismissed(String token, String id) async {
    await repository.deleteTodo(token, id);
    init(token);
  }
}

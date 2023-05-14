import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/domain/dtos/create_todo_dto.dart';

import '../../infraestructure/repositories/todo_repository_impl.dart';

class CreateTodoProvider extends ChangeNotifier {
  final TodoRepositoryImpl repository;

  CreateTodoProvider({TodoRepositoryImpl? repository})
      : repository = repository ?? TodoRepositoryImpl();

  bool executeTimeisActive = false;
  bool executeHourIsActive = false;
  FocusNode focusNode = FocusNode();

  DateTime executeTime = DateTime.now();
  DateTime executeHour = DateTime.now();

  String todoId = "";

  String title = "";

  int notificationIndex = 0;

  void init({
    DateTime? executeTime,
    DateTime? executeHour,
    String? title,
    String? todoId,
  }) {
    if (todoId == null) {
      focusNode.requestFocus();
      notifyListeners();
      return;
    }
    this.executeTime = executeTime ?? DateTime.now();
    this.executeHour = executeHour ?? DateTime.now();
    this.title = title ?? '';
    this.todoId = todoId;

    if (executeTime != null) {
      executeTimeisActive = true;
    }

    if (executeHour != null) {
      executeHourIsActive = true;
    }

    notifyListeners();
  }

  void changeExecuteTimeIsActive(bool newValue) {
    executeTimeisActive = newValue;
    notifyListeners();
  }

  void changeTitle(String newValue) {
    title = newValue;
    notifyListeners();
  }

  void changeNotificationIndex(int newValue) {
    notificationIndex = newValue;
    notifyListeners();
  }

  void changeExecuteHourIsActive(bool newValue) {
    executeHourIsActive = newValue;
    notifyListeners();
  }

  void changeExecuteTime(DateTime newDate) {
    executeTime = newDate;
    notifyListeners();
  }

  void changeExecuteHour(DateTime newDate) {
    executeHour = newDate;
    notifyListeners();
  }

  DateTime getNotificationDate(DateTime date, int notificationIndex) {
    if (notificationIndex == 0) {
      return date.subtract(const Duration(hours: 1));
    }

    if (notificationIndex == 1) {
      return date.subtract(const Duration(minutes: 30));
    }

    if (notificationIndex == 2) {
      return date.subtract(const Duration(minutes: 15));
    }

    if (notificationIndex == 3) {
      return date.subtract(const Duration(minutes: 5));
    }
    throw Error();
  }

  void createTodo(String token, BuildContext context) async {
    final date = DateTime.utc(
      executeTime.year,
      executeTime.month,
      executeTime.day,
      executeHour.hour,
      executeHour.minute,
    );

    final eventDay =
        DateTime.utc(executeTime.year, executeTime.month, executeTime.day);

    final notificationDate = getNotificationDate(date, notificationIndex);

    final CreateTodoDTO todoDTO = CreateTodoDTO(
      title: title,
      executeDay: date,
      eventDay: eventDay,
      notificationTime: notificationDate,
    );

    try {
      await repository.createTodo(token, todoDTO);
      context.pop(true);
    } catch (e) {
      context.pop(false);
    }
  }
}

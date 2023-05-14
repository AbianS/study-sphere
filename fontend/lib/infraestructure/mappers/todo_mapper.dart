import 'package:study_sphere_frontend/domain/entity/todo.dart';

class TodoMapper {
  static Todo todoJsonToEntity(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        executeDay: DateTime.parse(json['execute_day']),
        notificationTime: DateTime.parse(json['notification_time']),
        eventDay: DateTime.parse(json['event_day']),
        completed: json['completed'],
      );
}

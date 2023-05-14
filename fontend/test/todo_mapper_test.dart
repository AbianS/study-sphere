import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/infraestructure/mappers/todo_mapper.dart';

void main() {
  group('todo mapper todo', () {
    test('todoJsonToEntity should correctly convert JSON to Todo instance', () {
      final todoJson = {
        'id': "1",
        'title': 'Do laundry',
        'execute_day': '2022-05-16T14:30:00Z',
        'notification_time': '2022-05-16T13:30:00Z',
        'event_day': '2022-05-16T00:00:00Z',
        'completed': false,
      };

      final todo = TodoMapper.todoJsonToEntity(todoJson);

      expect(todo.id, "1");
      expect(todo.title, 'Do laundry');
      expect(todo.executeDay, DateTime.utc(2022, 5, 16, 14, 30));
      expect(todo.notificationTime, DateTime.utc(2022, 5, 16, 13, 30));
      expect(todo.eventDay, DateTime.utc(2022, 5, 16));
      expect(todo.completed, false);
    });

    test(
        'todoJsonToEntity should throw an error if any field has an unexpected type',
        () {
      final todoJson = {
        'id': '1', // should be an int
        'title': 'Do laundry',
        'execute_day': '2022-05-16T14:30:00Z',
        'notification_time': '2022-05-16T13:30:00Z',
        'event_day': '2022-05-16T00:00:00Z',
        'completed': 'false', // should be a bool
      };

      expect(() => TodoMapper.todoJsonToEntity(todoJson),
          throwsA(isA<TypeError>()));
    });
  });
}

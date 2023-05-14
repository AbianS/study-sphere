import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

void main() {
  group('todoDate', () {
    test('should format date correctly', () {
      final date = DateTime(2023, 05, 14);
      final result = Utils.todoDate(date);
      expect(result, 'Sunday, May 14');
    });

    test('should handle different day of the week correctly', () {
      final date = DateTime(2023, 5, 17);
      final result = Utils.todoDate(date);
      expect(result, 'Wednesday, May 17');
    });

    test('should handle single digit day correctly', () {
      final date = DateTime(2023, 5, 5);
      final result = Utils.todoDate(date);
      expect(result, 'Friday, May 5');
    });

    test('should handle different month correctly', () {
      final date = DateTime(2023, 6, 30);
      final result = Utils.todoDate(date);
      expect(result, 'Friday, June 30');
    });
  });
}

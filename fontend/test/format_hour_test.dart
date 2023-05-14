import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

void main() {
  group('formatHour', () {
    test('should format time correctly', () {
      final date = DateTime(2023, 05, 14, 10, 30);
      final result = Utils.formatHour(date);
      expect(result, '10:30 AM');
    });

    test('should handle single digit hours correctly', () {
      final date = DateTime(2023, 05, 14, 5, 30);
      final result = Utils.formatHour(date);
      expect(result, '5:30 AM');
    });

    test('should handle afternoon hours correctly', () {
      final date = DateTime(2023, 05, 14, 14, 30);
      final result = Utils.formatHour(date);
      expect(result, '2:30 PM');
    });

    test('should handle midnight hour correctly', () {
      final date = DateTime(2023, 05, 14, 0, 0);
      final result = Utils.formatHour(date);
      expect(result, '12:00 AM');
    });

    test('should handle noon hour correctly', () {
      final date = DateTime(2023, 05, 14, 12, 0);
      final result = Utils.formatHour(date);
      expect(result, '12:00 PM');
    });
  });
}

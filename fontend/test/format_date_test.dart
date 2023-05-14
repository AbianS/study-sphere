import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

void main() {
  group('formatDate', () {
    test('should format date correctly', () {
      final date = DateTime(2023, 10, 31, 22, 0);
      final result = Utils.formatDate(date);
      expect(result, '31 Oct 2023 22:00');
    });

    test('should handle leading zeros correctly', () {
      final date = DateTime(2023, 2, 5, 7, 5);
      final result = Utils.formatDate(date);
      expect(result, '5 Feb 2023 7:05');
    });

    test('should handle single digit month correctly', () {
      final date = DateTime(2023, 9, 12, 12, 0);
      final result = Utils.formatDate(date);
      expect(result, '12 Sep 2023 12:00');
    });
  });
}

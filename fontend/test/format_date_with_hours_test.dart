import 'package:flutter_test/flutter_test.dart';

import 'package:study_sphere_frontend/presentation/utils/utils.dart';

void main() {
  group('formatDateWithHours', () {
    test('should format date correctly', () {
      final date = DateTime(2023, 10, 31, 12, 0);
      final result = Utils.formatDateWithHours(date);
      expect(result, '31 Oct 2023');
    });

    test('should handle single digit day correctly', () {
      final date = DateTime(2023, 2, 5, 10, 30);
      final result = Utils.formatDateWithHours(date);
      expect(result, '5 Feb 2023');
    });

    test('should handle midnight correctly', () {
      final date = DateTime(2023, 9, 12, 0, 0);
      final result = Utils.formatDateWithHours(date);
      expect(result, '12 Sep 2023');
    });
  });
}

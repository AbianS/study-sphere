import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

void main() {
  group('simpleFormatDate', () {
    test('should format date correctly', () {
      final date = DateTime(2023, 10, 31);
      final result = Utils.simpleFormatDate(date);
      expect(result, '31 Oct');
    });

    test('should handle leading zeros correctly', () {
      final date = DateTime(2023, 2, 5);
      final result = Utils.simpleFormatDate(date);
      expect(result, '5 Feb');
    });

    test('should handle single digit month correctly', () {
      final date = DateTime(2023, 9, 12);
      final result = Utils.simpleFormatDate(date);
      expect(result, '12 Sep');
    });
  });
}

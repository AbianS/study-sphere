import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

void main() {
  group('humanDateFormat', () {
    test('should return seconds ago for difference less than 60 seconds', () {
      final date = DateTime.now().subtract(const Duration(seconds: 30));
      final result = Utils.humanDateFormat(date);
      expect(result, '30 segundos');
    });

    test('should return minutes ago for difference less than 60 minutes', () {
      final date = DateTime.now().subtract(const Duration(minutes: 30));
      final result = Utils.humanDateFormat(date);
      expect(result, '30 minutos');
    });

    test('should return hours ago for difference less than 24 hours', () {
      final date = DateTime.now().subtract(const Duration(hours: 5));
      final result = Utils.humanDateFormat(date);
      expect(result, '5 horas');
    });

    test('should return days ago for difference less than 7 days', () {
      final date = DateTime.now().subtract(const Duration(days: 3));
      final result = Utils.humanDateFormat(date);
      expect(result, '3 días');
    });

    test('should return formatted date for difference greater than 7 days', () {
      final date = DateTime.now().subtract(const Duration(days: 10));
      final result = Utils.humanDateFormat(date);
      expect(result, DateFormat('dd/MM/yyyy').format(date));
    });
  });
}

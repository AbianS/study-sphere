import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

void main() {
  group('getValidContentType', () {
    test('should return MediaType for jpg file', () {
      const path = '/path/to/image.jpg';
      final result = Utils.getValidContentType(path);
      expect(result.toString(), 'image/jpg');
    });

    test('should return MediaType for png file', () {
      const path = '/path/to/image.png';
      final result = Utils.getValidContentType(path);
      expect(result.toString(), 'image/png');
    });

    test('should return MediaType for pdf file', () {
      const path = '/path/to/document.pdf';
      final result = Utils.getValidContentType(path);
      expect(result.toString(), 'application/pdf');
    });

    test('should throw Error for unsupported file extension', () {
      const path = '/path/to/file.xyz';
      expect(() => Utils.getValidContentType(path), throwsA(isA<Error>()));
    });
  });
}

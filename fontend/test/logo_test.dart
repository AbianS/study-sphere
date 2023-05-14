import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/screens/login/widgets/common/login_logo.dart';

void main() {
  group('Logo widget', () {
    testWidgets('should render logo with image', (WidgetTester tester) async {
      await tester.pumpWidget(const Logo());
      final imageFinder = find.byType(Image);

      expect(imageFinder, findsOneWidget);
    });
  });
}

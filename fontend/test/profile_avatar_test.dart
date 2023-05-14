import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';

void main() {
  group('ProfileAvatar widget tests', () {
    testWidgets('Renders with name only', (WidgetTester tester) async {
      const widget = ProfileAvatar(name: 'John Doe', size: 50);

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      final textWidget = find.text('J');
      expect(textWidget, findsOneWidget);

      final circleAvatar = find.byType(CircleAvatar);
      expect(circleAvatar, findsOneWidget);

      final backgroundImage =
          tester.widget<CircleAvatar>(circleAvatar).backgroundImage;
      expect(backgroundImage, isNull);
    });

    testWidgets('Renders with no parameters', (WidgetTester tester) async {
      const widget = ProfileAvatar(name: null);

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: widget)));

      final textWidget = find.text('A');
      expect(textWidget, findsOneWidget);

      final circleAvatar = find.byType(CircleAvatar);
      expect(circleAvatar, findsOneWidget);

      final backgroundImage =
          tester.widget<CircleAvatar>(circleAvatar).backgroundImage;
      expect(backgroundImage, isNull);
    });
  });
}

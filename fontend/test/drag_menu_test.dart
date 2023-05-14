import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_sphere_frontend/presentation/common/desktop/drag_menu.dart';

void main() {
  group('drag menu test', () {
    testWidgets('DragMenu renders correctly with correct information',
        (WidgetTester tester) async {
      final onOpen = () {};
      final onClose = () {};
      final widget = DragMenu(
        thresholdActive: 30,
        onOpen: onOpen,
        onClose: onClose,
        axisOpen: DragMenuAxis.right,
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

      expect(find.byType(DragMenu), findsOneWidget);
    });
  });

  testWidgets(
      'DragMenu triggers onOpen event when dragged beyond threshold in right direction',
      (WidgetTester tester) async {
    bool onOpenTriggered = false;
    final onOpen = () {
      onOpenTriggered = true;
    };
    final onClose = () {};
    final widget = DragMenu(
      thresholdActive: 30,
      onOpen: onOpen,
      onClose: onClose,
      axisOpen: DragMenuAxis.right,
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    await tester.drag(find.byType(DragMenu), const Offset(40, 0));

    expect(onOpenTriggered, isTrue);
  });

  testWidgets(
      'DragMenu triggers onClose event when dragged beyond threshold in left direction',
      (WidgetTester tester) async {
    bool onCloseTriggered = false;
    final onOpen = () {};
    final onClose = () {
      onCloseTriggered = true;
    };
    final widget = DragMenu(
      thresholdActive: 30,
      onOpen: onOpen,
      onClose: onClose,
      axisOpen: DragMenuAxis.left,
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    await tester.drag(find.byType(DragMenu), const Offset(-40, 0));

    expect(onCloseTriggered, isTrue);
  });
}

import 'package:flutter/material.dart';

import '../../../config/theme/colors.dart';

enum DragMenuAxis { right, left }

class DragMenu extends StatefulWidget {
  final double thresholdActive;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final DragMenuAxis axisOpen;

  const DragMenu({
    super.key,
    required this.thresholdActive,
    required this.onOpen,
    required this.onClose,
    this.axisOpen = DragMenuAxis.right,
  });

  @override
  State<DragMenu> createState() => _DragMenuState();
}

class _DragMenuState extends State<DragMenu> {
  bool isHover = false;
  bool paint = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        setState(() {
          paint = true;
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          paint = false;
        });
      },
      onHorizontalDragUpdate: (details) {
        if (widget.axisOpen == DragMenuAxis.right) {
          if (details.localPosition.dx >= widget.thresholdActive) {
            widget.onOpen();
          }

          if (details.localPosition.dx <= -widget.thresholdActive) {
            widget.onClose();
          }
        }
        if (widget.axisOpen == DragMenuAxis.left) {
          if (details.localPosition.dx <= -widget.thresholdActive) {
            widget.onOpen();
          }

          if (details.localPosition.dx >= widget.thresholdActive) {
            widget.onClose();
          }
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 2,
              color: (isHover || paint)
                  ? MyColors.BLUE_LIGHT_BORDER_MENU
                  : MyColors.BORDER_GREY,
            ),
            Container(
              height: double.infinity,
              width: 6,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

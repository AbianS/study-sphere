import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';

class CustomWindowButton extends StatefulWidget {
  final Color colorHover;
  final Widget icon;
  final VoidCallback onPressed;
  final SystemMouseCursor? cursor;
  final double? width;
  final double? height;
  final String? label;
  final bool isExpanded;
  final bool isActive;

  const CustomWindowButton({
    super.key,
    required this.colorHover,
    required this.icon,
    required this.onPressed,
    this.cursor,
    this.width,
    this.height,
    this.label,
    this.isExpanded = false,
    this.isActive = false,
  });

  @override
  State<CustomWindowButton> createState() => _CustomWindowButtonState();
}

class _CustomWindowButtonState extends State<CustomWindowButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        cursor: (widget.cursor == null) ? MouseCursor.defer : widget.cursor!,
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
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: (widget.isExpanded) ? 10 : 0,
              vertical: (widget.isExpanded) ? 3 : 0),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.isActive
                  ? MyColors.PRIMARY_COLOR.withOpacity(0.2)
                  : isHover
                      ? widget.colorHover
                      : Colors.transparent,
              borderRadius: BorderRadius.circular((widget.isExpanded) ? 10 : 0),
            ),
            child: (widget.isExpanded)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        widget.icon,
                        const SizedBox(width: 10),
                        Text(widget.label!),
                      ],
                    ),
                  )
                : Center(
                    child: widget.icon,
                  ),
          ),
        ),
      ),
    );
  }
}

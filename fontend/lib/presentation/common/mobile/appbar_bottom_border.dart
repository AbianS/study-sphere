import 'package:flutter/material.dart';

class AppbarBottomDivider extends StatelessWidget
    implements PreferredSizeWidget {
  final Size size;

  const AppbarBottomDivider({
    super.key,
    this.size = const Size.fromHeight(1),
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: size,
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => preferredSize;
}

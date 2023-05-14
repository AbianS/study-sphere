import 'package:flutter/material.dart';

import 'custom_button.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // CustomWindowButton(
        //   onPressed: () => appWindow.minimize(),
        //   colorHover: const Color(0xfff2f2f2),
        //   icon: MinimizeIcon(color: Colors.black),
        //   width: 50,
        // ),
        // CustomWindowButton(
        //   onPressed: () => appWindow.maximizeOrRestore(),
        //   colorHover: const Color(0xfff2f2f2),
        //   icon: MaximizeIcon(color: Colors.black),
        //   width: 50,
        // ),
        // CustomWindowButton(
        //   onPressed: () => appWindow.close(),
        //   colorHover: const Color(0xffe81123),
        //   icon: CloseIcon(color: Colors.black),
        //   width: 50,
        // ),
      ],
    );
  }
}

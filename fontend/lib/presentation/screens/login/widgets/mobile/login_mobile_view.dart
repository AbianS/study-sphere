import 'package:flutter/material.dart';

import '../common/login_view.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          width: double.infinity,
          height: size.height,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LoginView(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:study_sphere_frontend/presentation/screens/login/widgets/common/login_logo.dart';

import 'login_footer.dart';
import 'login_form.dart';
import 'login_header.dart';

class LoginView extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool showLogo;

  const LoginView({
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        showLogo
            ? FadeInDown(
                child: const Logo(),
              )
            : const SizedBox(),
        const SizedBox(height: 30),
        FadeIn(
          delay: const Duration(milliseconds: 800),
          child: const Header(),
        ),
        const SizedBox(height: 20),
        const LoginForm(),
        const SizedBox(height: 10),
        FadeInUp(
          delay: const Duration(milliseconds: 1400),
          child: const Footer(),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

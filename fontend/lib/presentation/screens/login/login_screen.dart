import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/login_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/login/widgets/desktop/login_desktop_view.dart';
import 'package:study_sphere_frontend/presentation/screens/login/widgets/mobile/login_mobile_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => LoginProvider(authProvider),
        child: SafeArea(
          child: Builder(
            builder: (context) {
              if (defaultTargetPlatform == TargetPlatform.android) {
                return const MobileView();
              }
              return const DesktopView();
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/home_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/notification_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/home/widgets/desktop/home_desktop_view.dart';
import 'package:study_sphere_frontend/presentation/screens/home/widgets/mobile/home_mobile_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context, listen: false).user!.token;
    Provider.of<NotificationProvider>(context, listen: false)
        .requestPermission();

    return ChangeNotifierProvider(
      create: (context) => HomeProvider()..getClases(token),
      child: Builder(builder: (context) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          return const HomeMobileView();
        }
        return const HomeDesktopView();
      }),
    );
  }
}

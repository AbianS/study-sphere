import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/clase_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/widgets/mobile/clase_mobile_view.dart';

class ClaseScreen extends StatelessWidget {
  final String? classId;

  const ClaseScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? "";

    return ChangeNotifierProvider(
      create: (context) => ClaseProvider()..getClaseById(token, classId!),
      builder: (context, child) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          return const ClaseMobileView();
        }

        return Container();
      },
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    final authprovider = Provider.of<AuthProvider>(context, listen: false);

    if (mounted) {
      final value = await authprovider.isTheFirstTime(context);
      await authprovider.checkStatus(context);
      await Future.delayed(const Duration(milliseconds: 2600));

      if (value) {
        if (mounted) {
          context.go('/intro');
        }
      } else {
        if (authprovider.authStatus == AuthStatus.authenticated) {
          if (mounted) {
            context.go('/home');
          }
        } else if (mounted) {
          context.go('/login');
        }
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.PRIMARY_COLOR,
      body: SafeArea(
        child: Center(
          child: ZoomOut(
            delay: const Duration(milliseconds: 2500),
            child: FadeInDown(
              delay: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 1000),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Image.asset('assets/logo/logo.png'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

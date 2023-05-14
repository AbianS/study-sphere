import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ConnectivityScreen> createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends State<ConnectivityScreen> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          _isOnline = true;
          break;
        case InternetConnectionStatus.disconnected:
          _isOnline = false;
          break;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOnline) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 100),
              SvgPicture.asset(
                'assets/images/not-connection.svg',
                height: 400,
              ),
              const Text(
                'No tienes Conexión',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Por Favor revisa tu conexión a internet e inténtelo de nuevo',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: MyColors.PRIMARY_COLOR,
                ),
                child: const Center(
                  child: Text(
                    'Try Again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    return widget.child;
  }
}

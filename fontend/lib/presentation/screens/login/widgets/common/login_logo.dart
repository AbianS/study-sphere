import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({
    super.key,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Image.asset('assets/logo/logo.png'),
      ),
    );
  }
}

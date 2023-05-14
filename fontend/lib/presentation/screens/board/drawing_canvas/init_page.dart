import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';

class InitBoard extends StatelessWidget {
  const InitBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: SvgPicture.asset(
                  'assets/images/beta.svg',
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'Pizarra en Beta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInLeft(
                delay: const Duration(milliseconds: 400),
                child: const Text(
                  'La pizarra se encuentra en Beta, Pronto estará disponible para que pueda ser colaborativa y el profesor pueda usarla para dar de una mejor manera sus clases,',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => context.pushReplacement('/board'),
                child: FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: MyColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Text(
                        'Acceder',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();
    listContentConfig.addAll(
      [
        const ContentConfig(
          title: "Todas tus clases",
          description:
              "Accede a todas tus clases desde tu teléfono y desde cualquier lugar",
          styleTitle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          styleDescription: TextStyle(color: Colors.black),
          pathImage: "assets/intro/1.png",
          backgroundColor: Colors.white,
        ),
        const ContentConfig(
          title: "LLeva un control",
          description:
              "Puedes apuntar todas las tareas y asignaturas que tienes que estudiar y te mantendremos notificado",
          styleTitle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          styleDescription: TextStyle(color: Colors.black),
          pathImage: "assets/intro/2.png",
          backgroundColor: Colors.white,
        ),
        const ContentConfig(
          title: "Consigue resultados",
          description:
              "Haz que estudiar sea más fácil, y organizate con nuestra aplicación para alcanzar tus objetivos.",
          styleTitle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          styleDescription: TextStyle(color: Colors.black),
          pathImage: "assets/intro/3.png",
          backgroundColor: Colors.white,
        ),
        const ContentConfig(
          title: "Mantente en Contacto",
          description:
              "Ahora con nuestros chats es más fácil mantenerte conectado con tus compañeros de clase, al unirte a una clase podrás chatear con todos tus compañeros de esa clase.",
          styleTitle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          styleDescription: TextStyle(color: Colors.black),
          pathImage: "assets/intro/4.png",
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: () => context.go('/login'),
    );
  }
}

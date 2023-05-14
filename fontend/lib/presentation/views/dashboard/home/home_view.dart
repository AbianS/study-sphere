import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/providers/home_provider.dart';
import 'package:study_sphere_frontend/presentation/views/dashboard/home/widgets/desktop/dialogs/create_dialogs.dart';
import 'package:study_sphere_frontend/presentation/views/dashboard/home/widgets/desktop/dialogs/join_dialog.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeDesktopView();
  }
}

class _HomeDesktopView extends StatelessWidget {
  const _HomeDesktopView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            _Header(),
            SizedBox(height: 20),
            HomeClassList(),
          ],
        ),
      ),
    );
  }
}

class HomeClassList extends StatelessWidget {
  const HomeClassList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height - 150,
      child: Consumer<HomeProvider>(
        builder: (context, ref, child) {
          if (ref.homeStatus == HomeStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (ref.homeStatus == HomeStatus.loaded) {
            if (ref.clases!.isEmpty) {
              return const HomeNotClassWidget();
            } else {
              return SingleChildScrollView(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: ref.clases!
                      .map(
                        (clase) => (ClassCardDesktop(
                          title: clase.title,
                          teacherName: clase.teacherName == null
                              ? '${clase.students} students'
                              : clase.teacherName!,
                        )),
                      )
                      .toList(),
                ),
              );
            }
          }
          //TODO: Manejar Error
          return SizedBox();
        },
      ),
    );
  }
}

class HomeNotClassWidget extends StatelessWidget {
  const HomeNotClassWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/not-class.svg',
            height: 30.sh,
          ),
          const SizedBox(height: 10),
          Text(
            'Parece que no tienes ninguna clase',
            style: TextStyle(fontSize: 2.sh, fontWeight: FontWeight.w500),
          ),
          Text(
            'Unete o Crea una para empezar',
            style: TextStyle(fontSize: 1.sh, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}

class ClassCardDesktop extends StatelessWidget {
  const ClassCardDesktop({
    super.key,
    required this.title,
    required this.teacherName,
  });

  final String title;
  final String teacherName;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      width: 330,
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5, 10),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          SizedBox(
            width: 330,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz_outlined),
                      )
                    ],
                  ),
                  Text(
                    teacherName,
                    style: textStyle.bodyMedium,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isMobile;

  const _Header({
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mis Clases',
          style: textStyle.titleLarge!.copyWith(fontSize: 30),
        ),
        (isMobile)
            ? const SizedBox()
            : PopupMenuButton(
                offset: const Offset(-40, 20),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text('Unirse a clase'),
                      onTap: () {
                        Future.delayed(
                          const Duration(seconds: 0),
                          () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return JoinClassDialog(
                                homeProvider: homeProvider,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Crear una clase'),
                      onTap: () {
                        Future.delayed(
                          const Duration(seconds: 0),
                          () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CreateClassDialog(
                                homeProvider: homeProvider,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ];
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Añadir Clase',
                          style: textStyle.bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
      ],
    );
  }
}

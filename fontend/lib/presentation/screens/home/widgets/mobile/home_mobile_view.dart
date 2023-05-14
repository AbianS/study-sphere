import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/domain/entity/simple_class.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/home_provider.dart';
import 'package:study_sphere_frontend/presentation/views/dashboard/home/home_view.dart';

class HomeMobileView extends StatefulWidget {
  const HomeMobileView({super.key});

  @override
  State<HomeMobileView> createState() => _HomeMobileViewState();
}

class _HomeMobileViewState extends State<HomeMobileView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

    void _showBottomDialog(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Crear clase'),
                  onTap: () {
                    context.pop();
                    context.push(
                      '/home/create',
                      extra: {"homeProvider": homeProvider},
                    );
                  },
                ),
                ListTile(
                  title: const Text('Unirse a Clase'),
                  onTap: () {
                    context.pop();
                    context.push(
                      '/home/join',
                      extra: {"homeProvider": homeProvider},
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      key: scaffolKey,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        leading: FadeInLeft(
          child: IconButton(
            onPressed: () => scaffolKey.currentState!.openDrawer(),
            icon: const HeroIcon(HeroIcons.bars3),
          ),
        ),
        title: FadeInLeft(
          delay: const Duration(milliseconds: 100),
          child: const Text('Study Sphere'),
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, ref, child) {
              return FadeIn(
                child: ProfileAvatar(
                  name: ref.user?.name,
                  avatarUrl: ref.user?.avatar,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () => Provider.of<AuthProvider>(context, listen: false)
                .logout(context),
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, ref, child) {
          if (ref.homeStatus == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ref.homeStatus == HomeStatus.loaded) {
            if (ref.clases!.isEmpty) {
              return const HomeNotClassWidget();
            } else {
              return RefreshIndicator(
                onRefresh: () => ref.getClases(token),
                child: ListView.builder(
                  itemCount: ref.clases!.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    final clase = ref.clases![index];

                    return FadeInUp(
                      delay: Duration(milliseconds: index * 400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: _CardClass(
                          id: clase.id,
                          title: clase.title,
                          bg: clase.bg,
                          teacherName: (clase.teacherName == null)
                              ? '${clase.students} alumnos'
                              : clase.teacherName!,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }

          //TODO: En caso de fallo
          return const SizedBox();
        },
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          onPressed: () {
            _showBottomDialog(context);
          },
          child: const HeroIcon(HeroIcons.plus),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Study Sphere',
                    style: textStyle.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              SizedBox(
                height: size.height - 134, //TODO: Ajustar mejor
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {},
                      title: Text(
                        'Home',
                        style: textStyle.bodyLarge!
                            .copyWith(color: MyColors.PRIMARY_COLOR),
                      ),
                      leading: const HeroIcon(
                        HeroIcons.home,
                        style: HeroIconStyle.solid,
                        color: MyColors.PRIMARY_COLOR,
                      ),
                    ),
                    ListTile(
                      title: const Text('Chats'),
                      leading: const HeroIcon(HeroIcons.chatBubbleOvalLeft),
                      onTap: () {
                        context.pop();
                        context.push('/chats');
                      },
                    ),
                    ListTile(
                      title: const Text('Task'),
                      leading: const HeroIcon(HeroIcons.calendar),
                      onTap: () {
                        context.pop();
                        context.push('/todos');
                      },
                    ),
                    ListTile(
                      title: const Text('Board'),
                      leading: const HeroIcon(HeroIcons.pencilSquare),
                      onTap: () {
                        context.pop();
                        context.push('/intro-board');
                      },
                    ),
                    ListTile(
                      onTap: () => context.push('/profile'),
                      title: const Text('Profile'),
                      leading: const HeroIcon(HeroIcons.user),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Consumer<HomeProvider>(
                      builder: (context, ref, child) {
                        List<SimpleClase> classWhenImTeacher = ref.clases!
                            .where((clase) => clase.teacherName == null)
                            .toList();

                        if (classWhenImTeacher.isNotEmpty) {
                          ref.showDivider = true;
                        }

                        return classWhenImTeacher.isEmpty
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    'Clases impartidas',
                                    style: textStyle.bodySmall,
                                  ),
                                  const SizedBox(height: 5),
                                  ...classWhenImTeacher
                                      .map(
                                        (clase) => ListTile(
                                          onTap: () {
                                            context.push('/clase/${clase.id}');
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.orange,
                                            child: Text(
                                              clase.title
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                            ),
                                          ),
                                          title: Text(clase.title),
                                        ),
                                      )
                                      .toList(),
                                ],
                              );
                      },
                    ),
                    Consumer<HomeProvider>(
                      builder: (context, ref, child) {
                        List<SimpleClase> classWhenImStudent = ref.clases!
                            .where((clase) => clase.teacherName != null)
                            .toList();

                        return classWhenImStudent.isEmpty
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  if (ref.showDivider) const Divider(),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Cursos en los que te has inscrito',
                                    style: textStyle.bodySmall,
                                  ),
                                  const SizedBox(height: 5),
                                  ...classWhenImStudent
                                      .map(
                                        (clase) => ListTile(
                                          onTap: () {
                                            context.push('/clase/${clase.id}');
                                          },
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.orange,
                                            child: Text(
                                              clase.title
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                            ),
                                          ),
                                          title: Text(clase.title),
                                        ),
                                      )
                                      .toList(),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CardClass extends StatelessWidget {
  final String id;
  final String title;
  final String teacherName;
  final String bg;
  const _CardClass({
    required this.title,
    required this.teacherName,
    required this.bg,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/clase/$id');
      },
      child: Container(
        width: double.infinity,
        height: 16.sh,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(bg), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 10, top: 5, left: 20, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Text(
                teacherName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

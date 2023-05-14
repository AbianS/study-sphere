import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/clase_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/create_topic_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/widgets/mobile/views/board_view.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/widgets/mobile/views/people_view.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/widgets/mobile/views/work_view.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';

class ClaseMobileView extends StatelessWidget {
  const ClaseMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final List<Widget> views = [
      const BoardView(),
      const WorkView(),
      const PeopleView(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Consumer<ClaseProvider>(
          builder: (context, ref, child) {
            if (ref.currentIndex > 0) {
              return FadeIn(child: Text(ref.clase!.title));
            }

            return const SizedBox();
          },
        ),
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
        actions: [
          Consumer<ClaseProvider>(
            builder: (context, ref, child) {
              if (ref.currentIndex == 0) {
                return FadeIn(
                  child: IconButton(
                    onPressed: () {},
                    icon: ref.clase?.role == 'teacher'
                        ? const Icon(Icons.settings_outlined)
                        : const Icon(Icons.info_outline),
                  ),
                );
              }

              if (ref.currentIndex == 2 && ref.clase?.role == 'teacher') {
                return IconButton(
                  onPressed: () {
                    context.push(
                      '/clase/attendance',
                      extra: {"students": ref.clase!.students},
                    );
                  },
                  icon: const Icon(Icons.list_alt_outlined),
                );
              }

              return const SizedBox();
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Consumer<ClaseProvider>(
        builder: (context, ref, child) {
          if (ref.claseStatus == ClaseStatus.checking) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (ref.claseStatus == ClaseStatus.getClass) {
            return views[ref.currentIndex];
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: Consumer<ClaseProvider>(
        builder: (context, ref, child) {
          final claseId = ref.clase?.id ?? '';

          final textStyle = Theme.of(context).textTheme;
          if (ref.currentIndex == 1 && ref.clase!.role == "teacher") {
            return ZoomIn(
              delay: const Duration(milliseconds: 500),
              child: FloatingActionButton(
                onPressed: () {
                  final claseProvider = Provider.of<ClaseProvider>(
                    context,
                    listen: false,
                  );
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Text(
                              'Crear',
                              style: textStyle.titleLarge,
                            ),
                            ListTile(
                              leading: const Icon(Icons.text_snippet_outlined),
                              title: const Text('Tarea'),
                              onTap: () {
                                context.pop();
                                context.push(
                                  '/clase/create/task/$claseId',
                                  extra: {'claseProvider': claseProvider},
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.question_mark),
                              title: const Text('Pregunta'),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.book),
                              title: const Text('Material'),
                              onTap: () => context
                                  .push('/clase/create/material', extra: {
                                'classId': claseId,
                              }),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.text_snippet_rounded),
                              title: const Text('Tema'),
                              onTap: () async {
                                context.pop();
                                final res = await createTopicDialog(
                                    context, authProvider, claseId);

                                if (res) {
                                  ref.getClaseById(
                                      authProvider.user?.token ?? '', claseId);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: Consumer<ClaseProvider>(
        builder: (context, ref, child) {
          return BottomNavigationBar(
            currentIndex: ref.currentIndex,
            onTap: ref.changeCurrentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined),
                label: 'Tablón',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_alt_outlined),
                label: 'Trabajo de clase',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_outlined),
                label: 'Personas',
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> createTopicDialog(
    BuildContext context,
    AuthProvider authProvider,
    String claseId,
  ) async {
    return await showDialog(
      context: context,
      builder: (context) => Consumer<CreateTopicProvider>(
        builder: (context, ref, child) {
          final token = authProvider.user?.token ?? '';

          return AlertDialog(
            title: const Text('Crear tema'),
            scrollable: false,
            content: SizedBox(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Con los temas, las tareas se agrupan en una categoría'),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    hint: 'Tema',
                    onChanged: ref.changeTitle,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final res = await ref.submit(token, claseId);

                  if (res) {
                    return context.pop(true);
                  }

                  return context.pop(false);
                },
                child: const Text('Crear'),
              )
            ],
          );
        },
      ),
    );
  }
}

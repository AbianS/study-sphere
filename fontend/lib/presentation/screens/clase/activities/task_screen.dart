import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/task_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/teacher_provider.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskScreen extends StatelessWidget {
  final String taskId;

  const TaskScreen({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) =>
          TaskProvider()..getTaskById(authProvider.user?.token ?? '', taskId),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: Consumer<TaskProvider>(
            builder: (context, ref, child) {
              if (ref.status == TaskStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (ref.status == TaskStatus.allGod) {
                // TEACHER
                if (ref.task!.taskUser.isEmpty) {
                  return TeacherView(taskId: taskId);
                }

                // STUDENT
                return StudentView(taskId: taskId);
              }

              return const SizedBox(
                child: Text("Error"),
              );
            },
          ),
        );
      }),
    );
  }
}

class TeacherView extends StatelessWidget {
  final String taskId;

  const TeacherView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final String token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    return ChangeNotifierProvider(
      create: (context) => TeacherProvider()..getData(token, taskId),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Instrucciones'),
                Tab(text: 'Trabajo del alumno'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20)
                        .copyWith(top: 20),
                    child: const _Body(isTeacher: true),
                  ),
                  const _TeacherCorrectTask()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TeacherCorrectTask extends StatelessWidget {
  const _TeacherCorrectTask();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
      child: Consumer<TeacherProvider>(
        builder: (context, ref, child) {
          return Column(
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CustomCount(
                      value: ref.completeTask.length,
                      title: 'Asignado',
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                    ),
                    _CustomCount(
                      value: ref.completedTask,
                      title: 'Entregado',
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                    ),
                    _CustomCount(value: ref.gradeTask, title: 'Calificado')
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ListView.builder(
                    itemCount: ref.completeTask.length,
                    itemBuilder: (context, index) {
                      final task = ref.completeTask[index];
                      return ListTile(
                        leading: ProfileAvatar(
                          name: task.user.name,
                          avatarUrl: task.user.avatar,
                        ),
                        title: Text('${task.user.name} ${task.user.surname}'),
                        subtitle: Text(task.user.email),
                        trailing: task.completed
                            ? task.grade != null
                                ? Text("${task.grade} / ${task.task.score}")
                                : const Text(
                                    "Entregado",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  )
                            : const Text(
                                'Sin entregar',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                        onTap: () => context.push(
                          '/clase/task/grade',
                          extra: {
                            'completeTaskUser': task,
                            'teacherProvider': ref,
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _CustomCount extends StatelessWidget {
  final int value;
  final String title;
  const _CustomCount({
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title),
      ],
    );
  }
}

class StudentView extends StatelessWidget {
  final String taskId;

  const StudentView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final textStyle = Theme.of(context).textTheme;
    return ProgressHUD(
      child: Consumer<TaskProvider>(
        builder: (context, ref, child) {
          ref.progressHUD = ProgressHUD.of(context);

          return SlidingUpPanel(
            minHeight: 130,
            maxHeight: MediaQuery.of(context).size.height,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: null,
            border: Border.all(color: Colors.black26),
            panel: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(bottom: 120),
              child: Column(
                children: [
                  const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tu Trabajo',
                        style: textStyle.titleLarge,
                      ),
                      Text(
                        ref.task!.dueDate != null
                            ? Utils.formatDate(ref.task!.dueDate!)
                            : "Sin fecha de entrega",
                      )
                    ],
                  ),
                  (ref.task!.taskUser[0].files.isEmpty && ref.files.isEmpty)
                      ? Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Archivos adjuntos'),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/no-task.jpg',
                                  width: 200,
                                ),
                                const Text('No has adjuntado archivos')
                              ],
                            )
                          ],
                        )
                      : const SizedBox(
                          height: 150,
                          child: _ShowFilesContainer(),
                        ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Comentarios privados'),
                        Text('Añadir comentario a Abian Suarez'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Spacer(),
                  const Divider(),
                  const SizedBox(height: 10),
                  _ButtonTask(
                    onPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _CircleButton(
                                    text: 'Subir',
                                    icon: Icons.upload,
                                    onPress: () async {
                                      context.pop();
                                      FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(allowMultiple: true);

                                      if (result != null) {
                                        List<File> files = result.paths
                                            .map((path) => File(path!))
                                            .toList();

                                        ref.upadateFiles(files);
                                      }
                                    },
                                  ),
                                  _CircleButton(
                                    text: 'Insertar enlace',
                                    icon: Icons.link,
                                    onPress: () {},
                                  ),
                                  _CircleButton(
                                    text: 'Crear',
                                    icon: Icons.add,
                                    onPress: () async {
                                      context.pop();
                                      context.push(
                                        '/clase/doc',
                                        extra: {
                                          'taskId': taskId,
                                          'taskProvider': taskProvider
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    text: 'Añadir trabajo',
                    isPrimary: ref.files.isEmpty ? true : false,
                    icon: Icons.add,
                  ),
                  const SizedBox(height: 20),
                  _ButtonTask(
                    onPress: () async {
                      if (ref.files.isNotEmpty) {
                        await ref.solveTask(authProvider.user?.token ?? '');
                      }
                    },
                    isPrimary: ref.files.isEmpty ? false : true,
                    text: ref.files.isEmpty
                        ? 'Marcar como completado'
                        : 'Entregar',
                  )
                ],
              ),
            ),
            body: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _Body(),
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final bool isTeacher;

  const _Body({this.isTeacher = false});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Consumer<TaskProvider>(
      builder: (context, ref, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ref.task!.title, style: textStyle.titleLarge),
            Text('${ref.task!.score.toString()} puntos'),
            const Divider(),
            Text(ref.task!.description ?? ""),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                (ref.files.isNotEmpty)
                    ? const Text(
                        'Archivos Adjuntos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  height: 150,
                  child: _ShowFilesContainer(
                    isFull: false,
                    isTeacher: isTeacher,
                    isOnlyAttachments: true,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ShowFilesContainer extends StatelessWidget {
  final bool isFull;
  final bool isTeacher;
  final bool isOnlyAttachments;

  const _ShowFilesContainer({
    this.isFull = true,
    this.isTeacher = false,
    this.isOnlyAttachments = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, ref, child) {
        final List<dynamic> files = [];

        if (isOnlyAttachments) {
          files.addAll(ref.task!.files);
        } else {
          if (!isTeacher) {
            files.addAll(ref.task!.taskUser[0].files);
            if (isFull) {
              files.addAll(ref.files);
            }
          }

          if (!isFull) {
            files.addAll(ref.task!.files);
          }
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];

            return _CardFile(file: file);
          },
        );
      },
    );
  }
}

class _CardFile extends StatelessWidget {
  const _CardFile({
    super.key,
    required this.file,
  });

  final dynamic file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () async {
          if (file is String) {
            await launchUrl(Uri.parse(file));
          }
          if (file is File) {
            try {
              File newFile = file;
              await launchUrl(Uri.file(newFile.path));
            } catch (e) {
              print(e);
            }
          }
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100,
              width: 200,
              child:
                  Utils.getFileExtension(file is String ? file : file.path) ==
                          'jpg'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: file is String
                                ? NetworkImage(file) as ImageProvider
                                : FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            Utils.getFileExtension(
                                file is String ? file : file.path),
                          ),
                        ),
            ),
            SizedBox(
              width: 200,
              child: Text(
                file is String
                    ? file.split("/").last
                    : file.path.split("/").last,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPress;

  const _CircleButton({
    required this.icon,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26),
            ),
            child: Center(
              child: Icon(icon),
            ),
          ),
          const SizedBox(height: 5),
          Text(text)
        ],
      ),
    );
  }
}

class _ButtonTask extends StatelessWidget {
  final bool isPrimary;
  final String text;
  final IconData? icon;
  final VoidCallback onPress;

  const _ButtonTask({
    this.isPrimary = true,
    required this.text,
    this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: isPrimary ? MyColors.PRIMARY_COLOR : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: isPrimary ? null : Border.all(color: MyColors.PRIMARY_COLOR),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: isPrimary ? Colors.white : MyColors.PRIMARY_COLOR,
                  )
                : const SizedBox.shrink(),
            Text(
              text,
              style: TextStyle(
                color: isPrimary ? Colors.white : MyColors.PRIMARY_COLOR,
              ),
            )
          ],
        ),
      ),
    );
  }
}

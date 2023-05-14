import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/domain/entity/material.dart';
import 'package:study_sphere_frontend/domain/entity/question.dart';
import 'package:study_sphere_frontend/domain/entity/task.dart';
import 'package:study_sphere_frontend/domain/entity/topic.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/clase_provider.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

class WorkView extends StatelessWidget {
  const WorkView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        if (ref.clase?.topic == null) {
          return const Center(
            child: Text('Añade tareas y otros trabajos para la clase'),
          );
        }

        return ref.clase!.topic.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () =>
                    ref.getClaseById(authProvider.user!.token, ref.clase!.id),
                child: ListView.builder(
                  itemCount: ref.clase!.topic.length,
                  itemBuilder: (context, index) {
                    final topic = ref.clase!.topic[index];

                    return FadeInUp(
                      delay: Duration(milliseconds: index * 400),
                      child: Padding(
                        padding: EdgeInsets.only(top: (index == 0) ? 20 : 0),
                        child: _TopicSection(topic),
                      ),
                    );
                  },
                ),
              )
            : FadeInUp(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    height: size.height,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/not-work.jpg',
                          width: 80,
                        ),
                        const SizedBox(height: 20),
                        ref.clase!.role == 'teacher'
                            ? const Text(
                                'Añade tareas y otros trabajos para la clase y, despúes, organizalos por temas,',
                                textAlign: TextAlign.center,
                              )
                            : const Text(
                                'Tu profesor no ha asignado aún ningún trabajo de clase',
                                textAlign: TextAlign.center,
                              )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _TopicSection extends StatelessWidget {
  final Topic topic;

  const _TopicSection(this.topic);

  @override
  Widget build(BuildContext context) {
    List<dynamic> mergedList = [];

    mergedList.addAll(topic.material);
    mergedList.addAll(topic.question);
    mergedList.addAll(topic.task);

    mergedList.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final textStyle = Theme.of(context).textTheme;
    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        if (ref.claseStatus == ClaseStatus.checking) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (ref.clase!.role != 'teacher' && mergedList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topic.title,
                    style: textStyle.titleLarge,
                  ),
                  ref.clase!.role == 'teacher'
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                        )
                      : const SizedBox.shrink()
                ],
              ),
              const Divider(),
              (mergedList.isEmpty)
                  ? const Text(
                      'Los alumnos solo pueden ver los temas con publicaciones',
                    )
                  : Column(
                      children: [
                        ...mergedList.map(
                          (item) {
                            if (item.runtimeType == Task) {
                              return FadeInUp(
                                child: _TaskItem(item as Task, topic.id),
                              );
                            }
                            if (item.runtimeType == Question) {
                              return FadeInUp(
                                child: _QuestionItem(item as Question),
                              );
                            }

                            if (item.runtimeType == MaterialEntity) {
                              return FadeInUp(
                                child: _MaterialItem(item as MaterialEntity),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        )
                      ],
                    )
            ],
          ),
        );
      },
    );
  }
}

class _MaterialItem extends StatelessWidget {
  final MaterialEntity material;

  const _MaterialItem(this.material);

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        return ListTile(
          onTap: () =>
              context.push('/clase/material', extra: {"material": material}),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade500,
            child: const Icon(
              Icons.task_outlined,
              color: Colors.white,
            ),
          ),
          title: Text(material.title),
          subtitle: ref.clase!.role == "teacher"
              ? Text(
                  'Publicado hace: ${Utils.humanDateFormat(material.createdAt)}')
              : Text(
                  "Publicado el: ${Utils.formatDate(material.createdAt)}",
                ),
        );
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final String topicId;

  const _TaskItem(this.task, this.topicId);

  @override
  Widget build(BuildContext context) {
    final bool? completed;

    if (task.taskUser.isEmpty) {
      completed = null;
    } else {
      completed = task.taskUser[0].completed;
    }

    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        return ListTile(
          onTap: () => context.push('/clase/task', extra: {
            'taskId': task.id,
          }),
          leading: CircleAvatar(
            backgroundColor: completed == true ? Colors.grey : null,
            child: Icon(
              Icons.task,
              color: completed == true ? Colors.white : null,
            ),
          ),
          title: Text(task.title),
          subtitle: ref.clase!.role == "teacher"
              ? Text('Publicado hace: ${Utils.humanDateFormat(task.createdAt)}')
              : task.dueDate == null
                  ? const Text("Sin fecha de entega")
                  : Text(
                      "Fecha de entrega: ${Utils.formatDate(task.dueDate!)}",
                    ),
        );
      },
    );
  }
}

class _QuestionItem extends StatelessWidget {
  final Question question;

  const _QuestionItem(this.question);

  @override
  Widget build(BuildContext context) {
    final bool? completed;

    if (question.questionUser.isEmpty) {
      completed = null;
    } else {
      completed = question.questionUser[0].completed;
    }

    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        return ListTile(
          onTap: () {},
          leading: CircleAvatar(
            backgroundColor: completed == true ? Colors.grey : null,
            child: Icon(
              Icons.question_mark_outlined,
              color: completed == true ? Colors.white : null,
            ),
          ),
          title: Text(question.question),
          subtitle: ref.clase!.role == "teacher"
              ? Text(
                  'Publicado hace: ${Utils.humanDateFormat(question.createdAt)}')
              : question.dueDate == null
                  ? const Text("Sin fecha de entega")
                  : Text(
                      "Fecha de entrega: ${Utils.formatDate(question.dueDate!)}",
                    ),
        );
      },
    );
  }
}

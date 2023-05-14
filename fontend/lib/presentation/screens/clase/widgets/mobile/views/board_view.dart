import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:study_sphere_frontend/domain/entity/comment.dart';
import 'package:study_sphere_frontend/domain/entity/material.dart';
import 'package:study_sphere_frontend/domain/entity/task.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/annotation/annotation_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../providers/clase_provider.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/utils.dart';

class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final claseProvider = Provider.of<ClaseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () => claseProvider.getClaseById(
        authProvider.user?.token ?? '',
        claseProvider.clase!.id,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
          child: Column(
            children: [
              FadeInUp(
                child: const _CardHeader(),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: const _AddComment(),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: const _CommentList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentList extends StatelessWidget {
  const _CommentList();

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        List<dynamic> mergedList = [];
        mergedList.addAll(ref.clase!.comments);

        for (final topic in ref.clase!.topic) {
          mergedList.addAll(topic.material);
          mergedList.addAll(topic.question);
          mergedList.addAll(topic.task);
        }

        mergedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return mergedList.isNotEmpty
            ? Column(
                children: [
                  ...mergedList.map((item) {
                    if (item.runtimeType == Comment) {
                      return FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _Comment(comment: item as Comment),
                        ),
                      );
                    }

                    if (item.runtimeType == Task) {
                      return FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _Task(task: item as Task),
                        ),
                      );
                    }

                    if (item.runtimeType == MaterialEntity) {
                      return FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _Material(material: item as MaterialEntity),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  }),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/not-board.jpg',
                      width: 80,
                    ),
                    const SizedBox(height: 20),
                    ref.clase!.role == 'teacher'
                        ? const Text('Inicia una conversación con tu clase')
                        : const Text(
                            'Aún no hay publicaciones, pero compruébalo de nuevo en breve',
                            textAlign: TextAlign.center,
                          )
                  ],
                ),
              );
      },
    );
  }
}

class _Comment extends StatelessWidget {
  final Comment comment;

  const _Comment({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileAvatar(
                  name: comment.user.name,
                  avatarUrl: comment.user.avatar,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.user.name),
                    Text(DateFormat('dd MMM').format(comment.createdAt)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(comment.text),
            comment.files.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Archivos Adjuntos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 150,
                        child: _ShowFilesContainer(
                          files: comment.files,
                        ),
                      ),
                    ],
                  ),
            GestureDetector(
              onTap: () => context.push('/clase/annotation', extra: {
                'claseProvider':
                    Provider.of<ClaseProvider>(context, listen: false),
                'annotations': comment.annotations,
                'id': comment.id,
                'type': AnnotationType.COMMENT,
              }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 5),
                  comment.annotations.isNotEmpty
                      ? Text(
                          '${comment.annotations.length} comentario de clase',
                        )
                      : const Text("Añadir un comentario de clase")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ShowFilesContainer extends StatelessWidget {
  final List<String> files;

  const _ShowFilesContainer({required this.files});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async => await launchUrl(Uri.parse(file)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 100,
                      width: 200,
                      child: Utils.getFileExtension(file) == 'jpg'
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                image: NetworkImage(file),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                Utils.getFileExtension(file),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      file.split("/").last,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Task extends StatelessWidget {
  final Task task;
  const _Task({required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/clase/task', extra: {
        'taskId': task.id,
      }),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(
                      Icons.task,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title),
                      Text(DateFormat('dd MMM').format(task.createdAt)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
              GestureDetector(
                onTap: () => context.push('/clase/annotation', extra: {
                  'claseProvider':
                      Provider.of<ClaseProvider>(context, listen: false),
                  'annotations': task.annotations,
                  'id': task.id,
                  'type': AnnotationType.TASK,
                }),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 5),
                    task.annotations.isNotEmpty
                        ? Text(
                            '${task.annotations.length} comentario de clase',
                          )
                        : const Text("Añadir un comentario de clase")
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

class _Material extends StatelessWidget {
  final MaterialEntity material;

  const _Material({required this.material});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/clase/material', extra: {"material": material}),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(
                      Icons.task_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(material.title),
                      Text(DateFormat('dd MMM').format(material.createdAt)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
              GestureDetector(
                onTap: () => context.push('/clase/annotation', extra: {
                  'claseProvider':
                      Provider.of<ClaseProvider>(context, listen: false),
                  'annotations': material.annotations,
                  'id': material.id,
                  'type': AnnotationType.MATERIAL,
                }),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 5),
                    material.annotations.isNotEmpty
                        ? Text(
                            '${material.annotations.length} comentario de clase',
                          )
                        : const Text("Añadir un comentario de clase")
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

class _CardHeader extends StatelessWidget {
  const _CardHeader();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        return Container(
          width: double.infinity,
          height: 15.sh,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(ref.clase!.bg),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ref.clase!.title,
                  style: textStyle.titleLarge!.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Codigo de la clase: ${ref.clase!.id}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddComment extends StatelessWidget {
  const _AddComment();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Consumer<ClaseProvider>(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () => context.push(
            '/clase/create/comment',
            extra: {
              'classProvider': ref,
            },
          ),
          child: Container(
            height: 8.sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, ref, child) {
                      return ProfileAvatar(
                        name: ref.user!.name,
                        avatarUrl: ref.user?.avatar,
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text('Compartir con la clase...')
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

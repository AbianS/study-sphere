import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/domain/dtos/correct_class_dto.dart';
import 'package:study_sphere_frontend/domain/dtos/create_class_dto.dart';
import 'package:study_sphere_frontend/domain/entity/complete_task_user.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/teacher_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/common/profile_avatar.dart';
import '../../../utils/utils.dart';

class TaskGrade extends StatelessWidget {
  final CompleteTaskUser completeTaskUser;
  final TeacherProvider teacherProvider;
  const TaskGrade({
    super.key,
    required this.completeTaskUser,
    required this.teacherProvider,
  });

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Se actualizo la valoración correctamente",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    String text = "";
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(completeTaskUser.task.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ProfileAvatar(
              name: completeTaskUser.user.name,
              avatarUrl: completeTaskUser.user.avatar,
            ),
            title: Text(
                '${completeTaskUser.user.name} ${completeTaskUser.user.surname}'),
            subtitle: Text(completeTaskUser.user.email),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Archivos Adjuntos',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: completeTaskUser.files.length,
                    itemBuilder: (context, index) {
                      final file = completeTaskUser.files[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () async => await launchUrl(Uri.parse(file)),
                          child: Column(
                            children: [
                              Container(
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: CustomTextFormField(
                        keyboardType: TextInputType.number,
                        hint: "Calificación / ${completeTaskUser.task.score}",
                        onChanged: (p0) {
                          text = p0;
                        },
                        initialValue: completeTaskUser.grade != null
                            ? completeTaskUser.grade.toString()
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      CorrectTaskDTO correctTaskDTO = CorrectTaskDTO(
                        userId: completeTaskUser.user.id,
                        taskId: completeTaskUser.task.id,
                        grade: int.parse(text),
                      );
                      try {
                        teacherProvider.correctTask(token, correctTaskDTO);
                        _showToast();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.PRIMARY_COLOR,
                      ),
                      child: const Center(
                        child: Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/domain/dtos/create_task.dto.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/clase_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/theme/colors.dart';
import '../../../domain/entity/simple_topic.dart';

class CreateTaskScreen extends StatefulWidget {
  final ClaseRepositoryImpl repository;
  final ClaseProvider claseProvider;
  final String classId;

  CreateTaskScreen({
    super.key,
    required this.classId,
    ClaseRepositoryImpl? repository,
    required this.claseProvider,
  }) : repository = repository ?? ClaseRepositoryImpl();

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

enum CreateTaskStatus {
  chill,
  loading,
  allGood,
  errorPost,
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  bool isLoading = true;
  late AuthProvider authProvider;
  List<SimpleTopic>? topics;

  CreateTaskDTO? createTaskDTO;

  CreateTaskStatus createTaskStatus = CreateTaskStatus.chill;

  @override
  void initState() {
    authProvider = Provider.of(context, listen: false);
    createTaskDTO = CreateTaskDTO(classId: widget.classId);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    topics = await widget.repository
        .getAllTopics(authProvider.user?.token ?? '', widget.classId);
    isLoading = false;
    setState(() {});
    super.didChangeDependencies();
  }

  void createTask() async {
    createTaskStatus = CreateTaskStatus.loading;
    setState(() {});

    try {
      await widget.repository.createTask(
        authProvider.user?.token ?? '',
        createTaskDTO!,
      );
      createTaskStatus = CreateTaskStatus.allGood;
      setState(() {});
      widget.claseProvider.getClaseById(
        authProvider.user?.token ?? '',
        widget.classId,
      );
      Utils.showToast("La Tarea se creó correctamente");
    } catch (e) {
      createTaskStatus = CreateTaskStatus.errorPost;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String? dropdownValue;
    TextEditingController dateCtl = TextEditingController();

    return Scaffold(
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
        actions: [
          _PublishButton(
            onPress: () => createTask(),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
            child: Column(
              children: [
                CustomTextFormField(
                  hint: 'Título de la tarea',
                  onChanged: (p0) {
                    createTaskDTO!.title = p0;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hint: 'Descripción de la tarea',
                  onChanged: (p0) {
                    createTaskDTO!.description = p0;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hint: '100 puntos',
                  onChanged: (p0) {
                    createTaskDTO!.score = int.parse(p0);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateCtl,
                  decoration: InputDecoration(
                    hintText: "Fecha de Entrega",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () async {
                    DateTime? date = DateTime(1900);
                    FocusScope.of(context).requestFocus(FocusNode());

                    date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    createTaskDTO!.date = date;
                    dateCtl.text = date == null ? "" : date.toIso8601String();
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    hint: const Text("Tema"),
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        createTaskDTO!.topicId = dropdownValue ?? '';
                      });
                    },
                    items: topics!
                        .map<DropdownMenuItem<String>>((SimpleTopic topic) {
                      return DropdownMenuItem<String>(
                        value: topic.id,
                        child: Text(topic.title),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(allowMultiple: true);

                    if (result != null) {
                      createTaskDTO!.files =
                          result.paths.map((file) => File(file!)).toList();
                      setState(() {});
                    }
                  },
                ),
                createTaskDTO!.files != null && createTaskDTO!.files!.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Archivos Adjuntos',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: createTaskDTO!.files!.length,
                              itemBuilder: (context, index) {
                                final file = createTaskDTO!.files![index];

                                return CardFile(file: file);
                              },
                            ),
                          ),
                        ],
                      )
                    : SizedBox.fromSize()
              ],
            ),
          ),
        );
      }),
    );
  }
}

class CardFile extends StatelessWidget {
  const CardFile({
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

class _PublishButton extends StatelessWidget {
  final VoidCallback onPress;

  const _PublishButton({required this.onPress});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
          color: MyColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            'Publicar',
            style: textStyle.titleMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

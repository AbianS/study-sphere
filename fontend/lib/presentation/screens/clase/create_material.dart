import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/screens/clase/create_task.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';

import '../../../config/theme/colors.dart';
import '../../../domain/dtos/create_material.dart';
import '../../../domain/entity/simple_topic.dart';
import '../../../infraestructure/repositories/clase_repository_impl.dart';
import '../../providers/auth_provider.dart';

class CreateMaterial extends StatefulWidget {
  final ClaseRepositoryImpl repository;
  final String classId;

  CreateMaterial({
    super.key,
    ClaseRepositoryImpl? repository,
    required this.classId,
  }) : repository = repository ?? ClaseRepositoryImpl();

  @override
  State<CreateMaterial> createState() => _CreateMaterialState();
}

enum CreateMaterialStatus { chill, loading, allGood, errorPost }

class _CreateMaterialState extends State<CreateMaterial> {
  bool isLoading = true;
  late AuthProvider authProvider;
  List<SimpleTopic>? topics;

  CreateMaterialDTO? createMaterialDTO;

  CreateMaterialStatus createTaskStatus = CreateMaterialStatus.chill;

  @override
  void initState() {
    authProvider = Provider.of(context, listen: false);
    createMaterialDTO = CreateMaterialDTO(claseId: widget.classId);
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

  void _showToast() {
    Fluttertoast.showToast(
      msg: "El Material se creó correctamente",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  void createMaterial() async {
    createTaskStatus = CreateMaterialStatus.loading;
    setState(() {});

    try {
      await widget.repository.createMaterial(
        authProvider.user?.token ?? '',
        createMaterialDTO!,
      );
      createTaskStatus = CreateMaterialStatus.allGood;
      setState(() {});
      _showToast();
    } catch (e) {
      createTaskStatus = CreateMaterialStatus.errorPost;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String? dropdownValue;
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
            onPress: () => createMaterial(),
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
                  hint: 'Título del Material',
                  onChanged: (p0) {
                    createMaterialDTO!.tile = p0;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  hint: 'Descripción de la tarea',
                  onChanged: (p0) {
                    createMaterialDTO!.description = p0;
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
                        createMaterialDTO!.topicId = dropdownValue ?? '';
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
                      createMaterialDTO!.files =
                          result.paths.map((file) => File(file!)).toList();
                      setState(() {});
                    }
                  },
                ),
                createMaterialDTO!.files != null &&
                        createMaterialDTO!.files!.isNotEmpty
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
                              itemCount: createMaterialDTO!.files!.length,
                              itemBuilder: (context, index) {
                                final file = createMaterialDTO!.files![index];

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

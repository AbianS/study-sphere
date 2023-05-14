import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/domain/dtos/create_class_dto.dart';
import 'package:study_sphere_frontend/domain/dtos/create_comment.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/clase_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';

import '../../../config/theme/colors.dart';

class CreateCommentScreen extends StatefulWidget {
  final ClaseProvider claseProvider;
  const CreateCommentScreen({super.key, required this.claseProvider});

  @override
  State<CreateCommentScreen> createState() => _CreateCommentScreenState();
}

class _CreateCommentScreenState extends State<CreateCommentScreen> {
  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? "";

    final textStyle = Theme.of(context).textTheme;
    CreateCommentDTO createCommentDTO = CreateCommentDTO(
      classID: widget.claseProvider.clase!.id,
      text: "",
    );

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
          GestureDetector(
            onTap: () async {
              if (createCommentDTO.text.isNotEmpty) {
                await widget.claseProvider
                    .createComment(token, createCommentDTO);
              }
            },
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
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
        child: Column(
          children: [
            CustomTextFormField(
              hint: 'Compartir con la clase',
              onChanged: (p0) => createCommentDTO.text = p0,
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);

                if (result != null) {
                  createCommentDTO.files =
                      result.paths.map((file) => File(file!)).toList();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

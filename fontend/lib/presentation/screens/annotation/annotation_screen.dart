import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/domain/dtos/create_annotation.dart';
import 'package:study_sphere_frontend/domain/entity/annotation.dart';
import 'package:study_sphere_frontend/presentation/common/common/profile_avatar.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/clase_provider.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

enum AnnotationType { COMMENT, TASK, MATERIAL, QUESTION }

class AnnotationScreen extends StatefulWidget {
  final List<Annotation> annotations;
  final String id;
  final AnnotationType type;
  final ClaseProvider claseProvider;

  const AnnotationScreen({
    super.key,
    required this.annotations,
    required this.type,
    required this.id,
    required this.claseProvider,
  });

  @override
  State<AnnotationScreen> createState() => _AnnotationScreenState();
}

class _AnnotationScreenState extends State<AnnotationScreen> {
  final controller = TextEditingController();
  final _focusNode = FocusNode();
  String annotationText = "";

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios de la clase'),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.annotations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Todavía no hay ningún comentario de la clase')
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.annotations.length,
                      itemBuilder: (context, index) {
                        final annotation = widget.annotations[index];
                        return ListTile(
                          leading: ProfileAvatar(
                            name: annotation.user.name,
                            avatarUrl: annotation.user.avatar,
                          ),
                          title: Row(
                            children: [
                              Text(
                                annotation.user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                Utils.simpleFormatDate(annotation.createdAt),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          subtitle: Text(annotation.text),
                        );
                      },
                    ),
            ),
            Container(
              color: Colors.white,
              child: _InputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _InputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => _handleSubmit(),
                onChanged: (e) {
                  _writteText(e);
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                    color: MyColors.PRIMARY_COLOR,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _writteText(String newValue) {
    annotationText = newValue;
  }

  void _handleSubmit() {
    if (annotationText.isEmpty) return;

    CreateAnnotationDTO createAnnotationDTO = CreateAnnotationDTO(
      id: widget.id,
      type: widget.type,
      text: annotationText,
    );
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    widget.claseProvider.createAnnotation(token, createAnnotationDTO);
    _addToAnnotationList();

    controller.clear();
  }

  void _addToAnnotationList() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    AnnotationUser annotationUser = AnnotationUser(
      name: user!.name,
      avatar: user.avatar,
    );

    Annotation annotation = Annotation(
      id: "",
      text: annotationText,
      createdAt: DateTime.now(),
      user: annotationUser,
    );
    setState(() {
      widget.annotations.add(annotation);
    });
  }
}

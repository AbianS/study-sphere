import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/solve_task_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/task_provider.dart';

class DocScreen extends StatefulWidget {
  final String taskId;

  final TaskProvider taskProvider;

  const DocScreen({
    super.key,
    required this.taskId,
    required this.taskProvider,
  });

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  late HtmlEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = HtmlEditorController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SolveTaskProvider(),
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              _SaveButton(
                taskId: widget.taskId,
                taskProvider: widget.taskProvider,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: _Editor(controller: controller, widget: widget),
        ),
        onWillPop: _onBackPressed,
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Descartar cambios?'),
            content: const Text('Tus cambios se perderán'),
            actions: <Widget>[
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: const Text('Descartar'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class _Editor extends StatelessWidget {
  const _Editor({
    super.key,
    required this.controller,
    required this.widget,
  });

  final HtmlEditorController controller;
  final DocScreen widget;

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      callbacks: Callbacks(
        onChangeContent: (p0) =>
            Provider.of<SolveTaskProvider>(context, listen: false)
                .changeAnswerValue(p0),
      ),
      controller: controller,
      htmlEditorOptions:
          const HtmlEditorOptions(hint: 'Pulsar para escribir...'),
      otherOptions: OtherOptions(height: MediaQuery.of(context).size.height),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String taskId;
  final TaskProvider taskProvider;

  const _SaveButton({required this.taskId, required this.taskProvider});

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).user?.token ?? '';

    return Consumer<SolveTaskProvider>(
      builder: (context, ref, child) {
        return ref.status == TaskSolveStatus.posting
            ? const CircularProgressIndicator()
            : IconButton(
                onPressed: () {
                  Provider.of<SolveTaskProvider>(context, listen: false)
                      .submit(taskId, token, context, taskProvider);
                },
                icon: const Icon(Icons.save),
              );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/create_class_provider.dart';

import '../../../../config/theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/home_provider.dart';
import '../../common/widgets/text_form_field.dart';

class CreateClassScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  const CreateClassScreen({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => CreateClassProvider(authProvider, homeProvider),
      child: Scaffold(
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
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text('Crear Clase'),
          actions: [
            const _CreateButton(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
          child: Consumer<CreateClassProvider>(
            builder: (context, ref, child) {
              ref.progressHUD = ProgressHUD.of(context);
              return Column(
                children: [
                  CustomTextFormField(
                    hint: 'titulo de la clase (Obligatorio)',
                    onChanged: ref.changeTitle,
                    isValid: ref.isValid,
                    errorMessage: ref.isValid ? null : "Minimo 6 caracteres",
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    hint: "description about your class",
                    maxLines: 8,
                    onChanged: ref.changeDescription,
                  )
                ],
              );
            },
          )),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final token = Provider.of<AuthProvider>(context, listen: false).user!.token;
    return Consumer<CreateClassProvider>(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () {
            if (ref.isValid) ref.submit(context, token);
          },
          child: Container(
            width: 100,
            height: 35,
            decoration: BoxDecoration(
              color:
                  ref.isValid ? MyColors.PRIMARY_COLOR : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
            child: (ref.createStatus == CreateStatus.posting)
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'Crear',
                      style: textStyle.titleMedium!.copyWith(
                        color:
                            ref.isValid ? Colors.white : Colors.grey.shade500,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

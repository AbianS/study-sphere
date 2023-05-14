import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/create_class_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/home_provider.dart';

import '../../../../../../../config/theme/colors.dart';
import '../../../../../../screens/common/widgets/text_form_field.dart';

class CreateClassDialog extends StatelessWidget {
  final HomeProvider homeProvider;

  const CreateClassDialog({
    super.key,
    required this.homeProvider,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => CreateClassProvider(authProvider, homeProvider),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 510,
      height: 580,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            child: Container(
              width: 500,
              height: 540,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: MyColors.BORDER_GREY,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ).copyWith(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Crea Tu Propia Clase",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Para poder crear su clase especifique los siguientes apartado",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Form(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Title'),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                hint: 'titulo de la clase (Obligatorio)',
                                onChanged: Provider.of<CreateClassProvider>(
                                        context,
                                        listen: false)
                                    .changeTitle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Descriptions'),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                hint: "description about your class",
                                maxLines: 8,
                                onChanged: Provider.of<CreateClassProvider>(
                                        context,
                                        listen: false)
                                    .changeDescription,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Divider(),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          _CreateButton(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: _CloseButton(),
          ),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton();

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context, listen: false).user!.token;

    return Consumer<CreateClassProvider>(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () {
            if (ref.title.length >= 6) {
              ref.submit(context, token);
              context.pop();
            }
          },
          child: MouseRegion(
            cursor: (ref.title.length >= 6)
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            child: Container(
              width: 90,
              height: 40,
              decoration: BoxDecoration(
                color: (ref.title.length >= 6)
                    ? MyColors.PRIMARY_COLOR
                    : Colors.grey,
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              child: const Center(
                child: Text(
                  "Crear",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: MyColors.BORDER_GREY,
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.close,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

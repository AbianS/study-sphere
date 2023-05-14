import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/join_class_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';

import '../../../../../../providers/home_provider.dart';

class JoinClassDialog extends StatelessWidget {
  final HomeProvider homeProvider;

  const JoinClassDialog({
    super.key,
    required this.homeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JoinClassProvider(homeProvider),
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
      height: 350,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            child: Container(
              width: 500,
              height: 310,
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
                          "Unirse a una clase",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Ingrese el codigo entregado por el profesor y comienze a aprender",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Codigo'),
                        const SizedBox(height: 5),
                        Consumer<JoinClassProvider>(
                          builder: (context, ref, child) {
                            return CustomTextFormField(
                              hint: 'Codigo de la clase',
                              onChanged: ref.codeChange,
                              errorMessage: (ref.joinStatus ==
                                      JoinStatus.teacherError)
                                  ? "Eres profesor de esa clase"
                                  : (ref.joinStatus == JoinStatus.notExistErro)
                                      ? "No Existe esa clase"
                                      : ref.code.errorMessage,
                              isValid: (ref.joinStatus ==
                                          JoinStatus.teacherError ||
                                      ref.joinStatus == JoinStatus.notExistErro)
                                  ? false
                                  : ref.code.isValid,
                            );
                          },
                        ),
                      ],
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

    return Consumer<JoinClassProvider>(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () {
            if (ref.isValid) ref.submit(context, token);
          },
          child: MouseRegion(
            cursor: (ref.isValid)
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            child: Container(
              width: 90,
              height: 40,
              decoration: BoxDecoration(
                color: (ref.isValid)
                    ? MyColors.PRIMARY_COLOR
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              child: Center(
                child: Text(
                  "Unirse",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ref.isValid ? Colors.white : Colors.grey.shade500,
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

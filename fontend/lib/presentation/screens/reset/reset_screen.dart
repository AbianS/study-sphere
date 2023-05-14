import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/restore_password_provider.dart';

import '../../../config/theme/colors.dart';
import '../../providers/login_provider.dart';
import '../common/widgets/text_form_field.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Consumer<RestorePasswordProvider>(
      builder: (context, ref, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    child: const Text(
                      'Restablecer Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: const Text(
                      'Introduzca la cuenta de correo electrónico asociada y recibirá un correo electrónico con instrucciones para restablecer su contraseña.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: textStyle.bodyLarge,
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          onChanged: ref.emailChange,
                          errorMessage: (ref.formStatus == FormStatus.errorPost)
                              ? "Este email no tiene una cuenta en nuestro servicio"
                              : ref.email.errorMessage,
                          isValid: (ref.formStatus == FormStatus.errorPost)
                              ? false
                              : ref.email.isValid,
                          onFieldSubmitted: (_) => ref.submit(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => ref.submit(context),
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: MyColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: (ref.formStatus == FormStatus.posting)
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Enviar',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1000),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => ref.openDialog(context),
                        child: const Text("Ya tienes el codigo"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

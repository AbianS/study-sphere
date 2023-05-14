import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/login_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/register_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';
import 'package:study_sphere_frontend/presentation/screens/login/widgets/common/login_logo.dart';

import '../../../config/theme/colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(authProvider),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                width: double.infinity,
                height: size.height,
                child: const _RegisterView(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;
    return Consumer<RegisterProvider>(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(child: const Logo()),
              const SizedBox(height: 20),
              Row(
                children: [
                  FadeInLeft(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre', style: textStyle.bodyLarge),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: ((size.width / 2) - 25),
                          child: CustomTextFormField(
                            onChanged: ref.nameChange,
                            hint: 'Escribe tu Nombre',
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  FadeInRight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Apellidos', style: textStyle.bodyLarge),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: ((size.width / 2) - 25),
                          child: CustomTextFormField(
                            onChanged: ref.lastNameChange,
                            hint: 'Escribe tus Apellidos',
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email', style: textStyle.bodyLarge),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      hint: 'Escribe tu email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: ref.emailChange,
                      errorMessage: (ref.formStatus == FormStatus.errorPost)
                          ? "El email ya existe"
                          : ref.email.errorMessage,
                      isValid: (ref.formStatus == FormStatus.errorPost)
                          ? false
                          : ref.email.isValid,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FadeInLeft(
                delay: const Duration(milliseconds: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone', style: textStyle.bodyLarge),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      onChanged: ref.phoneChange,
                      hint: 'Escribe tu numero',
                      keyboardType: TextInputType.phone,
                      errorMessage: (ref.formStatus == FormStatus.errorPost)
                          ? "Email o Password Incorrecto"
                          : ref.phone.errorMessage,
                      isValid: (ref.formStatus == FormStatus.errorPost)
                          ? true
                          : ref.phone.isValid,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FadeInLeft(
                delay: const Duration(milliseconds: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password', style: textStyle.bodyLarge),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      hint: '******',
                      showIconHide: true,
                      obscureText: true,
                      onChanged: ref.passwordChange,
                      errorMessage: (ref.formStatus == FormStatus.errorPost)
                          ? "Email o Password Incorrecto"
                          : ref.password.errorMessage,
                      isValid: (ref.formStatus == FormStatus.errorPost)
                          ? true
                          : ref.password.isValid,
                      onFieldSubmitted: (_) => ref.submit(context),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FadeInLeft(
                delay: const Duration(milliseconds: 800),
                child: Row(
                  children: [
                    Checkbox(
                      value: ref.accept,
                      onChanged: ref.changeAccept,
                    ),
                    const Text('Aceptar los terminos y condiciones')
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => ref.submit(context),
                child: FadeInUp(
                  delay: const Duration(milliseconds: 1200),
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
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 1400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                    ),
                    TextButton(
                      child: const Text('Login'),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/confirm_password_provider.dart';

import '../../../config/theme/colors.dart';
import '../../providers/login_provider.dart';
import '../common/widgets/text_form_field.dart';

class RestartPasswordScreen extends StatelessWidget {
  final String email;

  const RestartPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final textStyle = Theme.of(context).textTheme;
    return ChangeNotifierProvider(
      create: (context) => ConfirmPasswordProvider(authProvider),
      child: Scaffold(
        appBar: AppBar(),
        body: _Body(email),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String email;
  const _Body(this.email);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Consumer<ConfirmPasswordProvider>(
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
                      'Crear nueva Contraseña',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: const Text(
                      'Su nueva contraseña debe ser diferente de las anteriores.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: textStyle.bodyLarge,
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          hint: '*******',
                          obscureText: true,
                          showIconHide: true,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: ref.passwordChange,
                          errorMessage: (ref.formStatus == FormStatus.errorPost)
                              ? "Las contraseñas deben coincidir"
                              : ref.password.errorMessage,
                          isValid: (ref.formStatus == FormStatus.errorPost)
                              ? true
                              : ref.password.isValid,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm Password',
                          style: textStyle.bodyLarge,
                        ),
                        const SizedBox(height: 5),
                        CustomTextFormField(
                          hint: '*******',
                          obscureText: true,
                          showIconHide: true,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: ref.confirmPasswordChange,
                          errorMessage: (ref.formStatus == FormStatus.errorPost)
                              ? "Las contraseñas deben coincidir"
                              : ref.confirmPassword.errorMessage,
                          isValid: (ref.formStatus == FormStatus.errorPost)
                              ? true
                              : ref.confirmPassword.isValid,
                          onFieldSubmitted: (_) => ref.submit(context, email),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => ref.submit(context, email),
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
                                  'Reeset Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
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

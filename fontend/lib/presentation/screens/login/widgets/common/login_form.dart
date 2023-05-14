import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/providers/login_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Form(
      child: Column(
        children: [
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
                Consumer<LoginProvider>(
                  builder: (context, ref, child) {
                    return CustomTextFormField(
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: ref.emailChange,
                      errorMessage: (ref.formStatus == FormStatus.errorPost)
                          ? "Email o Password Incorrectos"
                          : ref.email.errorMessage,
                      isValid: (ref.formStatus == FormStatus.errorPost)
                          ? false
                          : ref.email.isValid,
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          FadeInLeft(
            delay: const Duration(milliseconds: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: textStyle.bodyLarge,
                ),
                const SizedBox(height: 5),
                Consumer<LoginProvider>(
                  builder: (context, ref, child) {
                    return CustomTextFormField(
                      hint: '********',
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
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          FadeInLeft(
            delay: const Duration(milliseconds: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Consumer<LoginProvider>(
                      builder: (context, ref, child) {
                        return Checkbox(
                          value: ref.rememberMe,
                          onChanged: ref.changeRememberMe,
                        );
                      },
                    ),
                    const Text('Remember Me')
                  ],
                ),
                TextButton(
                  child: const Text('Forgot Password'),
                  onPressed: () => context.push('/reset'),
                )
              ],
            ),
          ),
          // ignore: prefer_const_constructors
          SizedBox(height: 10),
          Consumer<LoginProvider>(
            builder: (context, ref, child) {
              return FadeInUp(
                delay: const Duration(milliseconds: 1400),
                child: GestureDetector(
                  onTap: () => ref.submit(context),
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
                              'Sign in',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

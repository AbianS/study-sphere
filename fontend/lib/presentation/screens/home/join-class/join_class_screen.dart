import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/config/theme/colors.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/home_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/join_class_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';

class JoinClassScreen extends StatelessWidget {
  final HomeProvider homeProvider;
  const JoinClassScreen({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JoinClassProvider(homeProvider),
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
          title: const Text('Unirse a clase'),
          actions: [
            const _JoinButton(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_outlined),
            ),
          ],
        ),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return ProgressHUD(
      child: Consumer<JoinClassProvider>(
        builder: (context, ref, child) {
          ref.progressHUD = ProgressHUD.of(context);
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Has iniciado sesión como',
                  style: textStyle.titleMedium,
                ),
                const SizedBox(height: 20),
                const _UserInfo(),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Pídele a tu profesor el código de la clase e intrdodúcelo aquí.',
                ),
                const SizedBox(height: 20),
                const _CodeInput(),
                const SizedBox(height: 20),
                Text(
                  'Para iniciar sesión con un código de clase',
                  style: textStyle.titleMedium,
                ),
                const SizedBox(height: 10),
                const Text('\u2022 Usa una cuenta autorizada'),
                const SizedBox(height: 10),
                const Text(
                  '\u2022 Usa un código de clase con 7 letras y números, y sin espacios ni símbolos',
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

//TODO: reutilizar -> create y join usan lo mismo
class _JoinButton extends StatelessWidget {
  const _JoinButton();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final token = Provider.of<AuthProvider>(context, listen: false).user!.token;
    return Consumer<JoinClassProvider>(
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
            child: (ref.joinStatus == JoinStatus.posting)
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
                      'Unirme',
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

class _CodeInput extends StatelessWidget {
  const _CodeInput();

  @override
  Widget build(BuildContext context) {
    return Consumer<JoinClassProvider>(
      builder: (context, ref, child) {
        return CustomTextFormField(
          hint: 'Código de clase',
          onChanged: ref.codeChange,
          errorMessage: (ref.joinStatus == JoinStatus.teacherError)
              ? "Eres profesor de esa clase"
              : (ref.joinStatus == JoinStatus.notExistErro)
                  ? "No Existe esa clase"
                  : ref.code.errorMessage,
          isValid: (ref.joinStatus == JoinStatus.teacherError ||
                  ref.joinStatus == JoinStatus.notExistErro)
              ? false
              : ref.code.isValid,
        );
      },
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Consumer<AuthProvider>(
      builder: (context, ref, child) {
        return Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.pink,
              child: Text(ref.user!.name.substring(0, 1).toUpperCase()),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ref.user!.name} ${ref.user!.surname}',
                  style: textStyle.titleSmall,
                ),
                Text(ref.user!.email),
              ],
            )
          ],
        );
      },
    );
  }
}

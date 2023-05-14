import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/email.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/login_provider.dart';
import 'package:study_sphere_frontend/presentation/screens/common/widgets/text_form_field.dart';
import 'package:study_sphere_frontend/presentation/utils/utils.dart';

class RestorePasswordProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  RestorePasswordProvider(this.authProvider);

  FormStatus _formStatus = FormStatus.invalid;
  Email _email = const Email.pure();
  bool _isValid = false;
  String _code = "";

  FormStatus codeStatus = FormStatus.invalid;

  // getters
  FormStatus get formStatus => _formStatus;
  Email get email => _email;
  bool get isValid => _isValid;
  String get code => _code;

  void submit(BuildContext context) async {
    if (!isValid) {
      _email = Email.dirty(_email.value);
      notifyListeners();
    }
    if (_isValid) {
      await _resetPassword(context);
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      _formStatus = FormStatus.posting;
      notifyListeners();
      final result = await authProvider.restorePassword(
        email: email.value,
      );
      if (!result) {
        _formStatus = FormStatus.errorPost;
        notifyListeners();
        return;
      }

      _formStatus = FormStatus.allGood;
      notifyListeners();
      openDialog(context);
    } catch (e) {
      _formStatus = FormStatus.errorPost;
      notifyListeners();
    }
  }

  void emailChange(String value) {
    _email = Email.dirty(value);
    _formStatus = FormStatus.writting;
    _isValid = Formz.validate([_email]);
    notifyListeners();
  }

  void codeChange(String value) {
    _code = value;
    codeStatus = FormStatus.writting;
    notifyListeners();
  }

  Future<void> checkRestoreCode(BuildContext context) async {
    try {
      final response = await authProvider.checkRestorePassword(
        email: email.value,
        code: code,
      );

      if (response) {
        Utils.showToast("El codigo Introducido es valido");
        context.pop();
        context.push('/restart-password/${email.value}');
      } else {
        codeStatus = FormStatus.errorPost;
        notifyListeners();
      }
    } catch (e) {
      codeStatus = FormStatus.errorPost;
      notifyListeners();
    }
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 280,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Consumer<RestorePasswordProvider>(
                builder: (context, ref, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingrese el codigo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                          'Introduzca el codigo que se envio a su correo: ${email.value}'),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        hint: 'Codigo',
                        onChanged: ref.codeChange,
                        errorMessage: (ref.codeStatus == FormStatus.errorPost)
                            ? "El código no es valido"
                            : null,
                        isValid: (ref.codeStatus == FormStatus.errorPost)
                            ? false
                            : false,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: const Text('Enviar'),
                          onPressed: () => ref.checkRestoreCode(context),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

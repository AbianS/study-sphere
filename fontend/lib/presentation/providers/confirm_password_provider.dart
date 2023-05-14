import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/password.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/login_provider.dart';

class ConfirmPasswordProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  ConfirmPasswordProvider(this.authProvider);

  FormStatus _formStatus = FormStatus.invalid;
  Password _password = Password.pure();
  Password _confirmPassword = Password.pure();
  bool _isValid = false;

  //getters
  FormStatus get formStatus => _formStatus;
  Password get password => _password;
  Password get confirmPassword => _confirmPassword;
  bool get isValid => _isValid;

  void submit(BuildContext context, String email) async {
    if (!_isValid) {
      _password = Password.dirty(_password.value);
      _confirmPassword = Password.dirty(_confirmPassword.value);
      notifyListeners();
    }

    if (_isValid) {
      if (_password.value != _confirmPassword.value) {
        _formStatus = FormStatus.errorPost;
        notifyListeners();
        return;
      }

      await _reset(context, email);
    }
  }

  Future<void> _reset(BuildContext context, String email) async {
    try {
      _formStatus = FormStatus.posting;
      notifyListeners();
      await authProvider.confirmRestorePassword(
        email: email,
        password: password.value,
      );
      _formStatus = FormStatus.allGood;
      _showToast();
      context.go('/login');
      notifyListeners();
    } catch (e) {
      _formStatus = FormStatus.errorPost;
      notifyListeners();
    }
  }

  void passwordChange(String value) {
    _password = Password.dirty(value);
    _formStatus = FormStatus.writting;
    _isValid = Formz.validate([_password, _confirmPassword]);
    notifyListeners();
  }

  void confirmPasswordChange(String value) {
    _confirmPassword = Password.dirty(value);
    _formStatus = FormStatus.writting;
    _isValid = Formz.validate([_confirmPassword, _password]);
    notifyListeners();
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Contraseña Actualizada",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}

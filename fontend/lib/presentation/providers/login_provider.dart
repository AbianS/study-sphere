import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/email.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/password.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';

enum FormStatus {
  invalid,
  valid,
  validating,
  posting,
  allGood,
  errorPost,
  writting
}

class LoginProvider extends ChangeNotifier {
  final AuthProvider _authProvider;

  LoginProvider(this._authProvider);

  bool rememberMe = false;

  FormStatus _formStatus = FormStatus.invalid;
  Email _email = const Email.pure();
  Password _password = const Password.pure();
  bool _isValid = false;

  // getters
  FormStatus get formStatus => _formStatus;
  Email get email => _email;
  Password get password => _password;
  bool get isValid => _isValid;

  void submit(BuildContext context) async {
    if (!_isValid) {
      _email = Email.dirty(_email.value);
      _password = Password.dirty(_password.value);
      notifyListeners();
    }
    if (_isValid) {
      await _login(context);
    }
  }

  void changeRememberMe(bool? newValue) {
    rememberMe = newValue!;
    notifyListeners();
  }

  Future<void> _login(BuildContext context) async {
    try {
      _formStatus = FormStatus.posting;
      notifyListeners();
      await _authProvider.login(
        context: context,
        email: _email.value,
        password: _password.value,
      );
      _formStatus = FormStatus.allGood;
      notifyListeners();
    } catch (e) {
      _formStatus = FormStatus.errorPost;
      notifyListeners();
    }
  }

  void emailChange(String value) {
    _email = Email.dirty(value);
    _formStatus = FormStatus.writting;
    _isValid = Formz.validate([_email, _password]);
    notifyListeners();
  }

  void passwordChange(String value) {
    _password = Password.dirty(value);
    _formStatus = FormStatus.writting;
    _isValid = Formz.validate([_email, _password]);
    notifyListeners();
  }
}

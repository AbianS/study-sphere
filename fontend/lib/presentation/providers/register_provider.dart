import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:study_sphere_frontend/domain/dtos/register.dto.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/email.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/password.dart';
import 'package:study_sphere_frontend/infraestructure/inputs/phone.dart';
import 'package:study_sphere_frontend/presentation/providers/auth_provider.dart';
import 'package:study_sphere_frontend/presentation/providers/login_provider.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthProvider authProvider;

  RegisterProvider(this.authProvider);

  bool accept = false;

  FormStatus _formStatus = FormStatus.invalid;
  Email _email = const Email.pure();
  Password _password = const Password.pure();
  String _name = "";
  String _lastName = "";
  Phone _phone = const Phone.pure();
  bool _isValid = false;

  // getters
  FormStatus get formStatus => _formStatus;
  Email get email => _email;
  Password get password => _password;
  bool get isValid => _isValid;
  String get name => _name = "";
  String get lastName => _lastName = "";
  Phone get phone => _phone;

  void changeAccept(bool? newValue) {
    accept = newValue!;
    notifyListeners();
  }

  void submit(BuildContext context) async {
    if (!_isValid) {
      _email = Email.dirty(_email.value);
      _password = Password.dirty(_password.value);
      notifyListeners();
    }

    if (_isValid) {
      await _register(context);
    }
  }

  Future<void> _register(BuildContext context) async {
    try {
      RegisterDTO registerDTO = RegisterDTO(
        name: _name,
        surname: _lastName,
        email: _email.value,
        password: _password.value,
        phone: _phone.value,
      );
      _formStatus = FormStatus.posting;
      notifyListeners();
      await authProvider.register(
        context: context,
        registerDTO: registerDTO,
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
    _isValid = Formz.validate([_email, _password, _phone]);
    notifyListeners();
  }

  void nameChange(String value) {
    _name = value;
    notifyListeners();
  }

  void lastNameChange(String value) {
    _lastName = value;
    notifyListeners();
  }

  void phoneChange(String value) {
    _phone = Phone.dirty(value);
    _formStatus = FormStatus.writting;
    _isValid = Formz.validate([_email, _password, _phone]);
    notifyListeners();
  }

  void passwordChange(String value) {
    _password = Password.dirty(value);
    _formStatus = FormStatus.writting;
    _isValid = Formz.validate([_email, _password, _phone]);
    notifyListeners();
  }
}

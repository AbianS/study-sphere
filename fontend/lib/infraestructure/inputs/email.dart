import 'package:formz/formz.dart';

enum EmailError {
  empty,
  format,
  notExist,
}

class Email extends FormzInput<String, EmailError> {
  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  const Email.pure() : super.pure('');

  const Email.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == EmailError.empty) return 'El campo es requerido';
    if (displayError == EmailError.format) return 'No tiene formato de email';

    return null;
  }

  @override
  EmailError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return EmailError.empty;
    if (!emailRegExp.hasMatch(value)) return EmailError.format;

    return null;
  }
}

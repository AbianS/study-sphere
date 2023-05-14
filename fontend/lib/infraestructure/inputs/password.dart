import 'package:formz/formz.dart';

enum PasswordError { empty, lenght, notFound }

class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');

  const Password.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PasswordError.empty) return "El campo es requerido";
    if (displayError == PasswordError.lenght) return "Mínimo 6 caracteres";

    return null;
  }

  @override
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.length < 6) return PasswordError.lenght;

    return null;
  }
}

import 'package:formz/formz.dart';

enum CodeError {
  empty,
  format,
  notExist,
}

class Code extends FormzInput<String, CodeError> {
  static final RegExp codeRegExp = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{7}$',
  );

  const Code.pure() : super.pure('');
  const Code.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == CodeError.empty) return "El campo es requerido";
    if (displayError == CodeError.format) return "No tiene el formato correcto";

    return null;
  }

  @override
  CodeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return CodeError.empty;
    if (!codeRegExp.hasMatch(value)) return CodeError.format;
  }
}

import 'package:formz/formz.dart';

enum PhoneError { empty, lenght, notFound }

class Phone extends FormzInput<String, PhoneError> {
  const Phone.pure() : super.pure('');

  const Phone.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PhoneError.empty) return "El campo es requerido";
    if (displayError == PhoneError.lenght) return "Phone no valido";

    return null;
  }

  @override
  PhoneError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PhoneError.empty;
    if (value.length < 9) return PhoneError.lenght;

    return null;
  }
}

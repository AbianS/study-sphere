import 'dart:io';

class UpdateUserDTO {
  String? name;
  String? surname;
  String? phone;
  File? file;

  UpdateUserDTO({
    this.name,
    this.surname,
    this.phone,
    this.file,
  });

  Map<String, dynamic> topMap() {
    return {
      'name': name,
      'surname': surname,
      'phone': phone,
    };
  }
}

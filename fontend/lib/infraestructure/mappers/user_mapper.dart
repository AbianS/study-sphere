import 'package:study_sphere_frontend/config/constants/enviroment.dart';
import 'package:study_sphere_frontend/domain/entity/simple_user.dart';

import '../../domain/entity/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        surname: json['surname'],
        avatar: json['avatar'],
        phone: json['phone'],
        token: json['token'],
      );

  static Map<String, dynamic> userEntityToJson(User user) {
    return {
      "id": user.id,
      "email": user.email,
      "name": user.name,
      "surname": user.surname,
      "phone": user.phone,
      "token": user.token,
    };
  }

  static SimpleUser simpleUserJsonToEntity(Map<String, dynamic> json) =>
      SimpleUser(
        name: json['name'],
        email: json['email'],
        avatar: json['avatar'] != null ? "${json['avatar']}" : null,
      );

  static SimpleUser simpleUserOnlyNameJsonToEntity(Map<String, dynamic> json) =>
      SimpleUser(
        name: '${json['name']} ${json['surname']}',
        avatar: json['avatar'] != null ? "${json['avatar']}" : null,
      );

  static Map<String, dynamic> simpleUserEntityToJson(SimpleUser user) {
    return {
      "name": user.name,
      "email": user.email,
    };
  }
}

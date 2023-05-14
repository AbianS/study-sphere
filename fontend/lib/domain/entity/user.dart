class User {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String phone;
  final String? avatar;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
    required this.token,
    this.avatar,
  });
}

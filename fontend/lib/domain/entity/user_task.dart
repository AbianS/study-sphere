class UserTask {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String? avatar;

  UserTask({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.avatar,
  });
}

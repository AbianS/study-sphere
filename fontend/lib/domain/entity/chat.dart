class Chat {
  final String id;
  final String? avatar;
  final String name;
  final String surname;
  final String email;

  Chat({
    required this.id,
    this.avatar,
    required this.name,
    required this.surname,
    required this.email,
  });
}

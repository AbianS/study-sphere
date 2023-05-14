class Annotation {
  final String id;
  final String text;
  final DateTime createdAt;
  final AnnotationUser user;

  Annotation({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.user,
  });
}

class AnnotationUser {
  final String name;
  final String? avatar;

  AnnotationUser({
    required this.name,
    this.avatar,
  });
}

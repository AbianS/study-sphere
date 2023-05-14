class SimpleClase {
  String id;
  String title;
  String description;
  int students;
  String bg;
  String? teacherName;

  SimpleClase({
    required this.id,
    required this.title,
    required this.description,
    required this.students,
    required this.bg,
    this.teacherName,
  });
}

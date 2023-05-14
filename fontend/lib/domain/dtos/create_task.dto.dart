import 'dart:io';

class CreateTaskDTO {
  String? title;
  String? description;
  String? topicId;
  String classId;
  int? score;
  DateTime? date;
  List<File>? files;

  CreateTaskDTO({
    this.title,
    this.description,
    this.topicId,
    required this.classId,
    this.score,
    this.date,
    this.files,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'classId': classId,
      'topicId': topicId,
      'description': description,
      'dueDate': date?.toIso8601String(),
      'score': score,
    };
  }
}

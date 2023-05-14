import 'dart:io';

class CreateCommentDTO {
  String classID;
  String text;
  List<File>? files;

  CreateCommentDTO({
    required this.classID,
    required this.text,
    this.files,
  });

  Map<String, dynamic> toMap() {
    return {
      "claseId": classID,
      "text": text,
    };
  }
}

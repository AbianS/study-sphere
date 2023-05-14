import 'dart:io';

class CreateMaterialDTO {
  String? tile;
  String? description;
  List<File>? files;
  String? topicId;
  String claseId;

  CreateMaterialDTO({
    this.tile,
    this.description,
    required this.claseId,
    this.topicId,
    this.files,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": tile,
      "description": description,
      "topicId": topicId,
      "claseId": claseId,
    };
  }
}

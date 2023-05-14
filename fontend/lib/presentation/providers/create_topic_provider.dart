import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_sphere_frontend/domain/dtos/create_topic_dto.dart';
import 'package:study_sphere_frontend/infraestructure/repositories/clase_repository_impl.dart';

enum TopicStatus {
  invalid,
  valid,
  posting,
  writting,
}

class CreateTopicProvider extends ChangeNotifier {
  final ClaseRepositoryImpl repository;
  CreateTopicProvider({ClaseRepositoryImpl? repository})
      : repository = repository ?? ClaseRepositoryImpl();

  String _title = "";
  TopicStatus _topicStatus = TopicStatus.writting;

  void changeTitle(String newValue) {
    _title = newValue;
    notifyListeners();
  }

  Future<bool> submit(String token, String claseId) async {
    _topicStatus = TopicStatus.posting;
    notifyListeners();
    CreateTopicDTO createTopicDTO = CreateTopicDTO(
      title: _title,
      claseId: claseId,
      token: token,
    );

    try {
      await repository.createTopic(createTopicDTO);
      _topicStatus = TopicStatus.valid;
      notifyListeners();
      reset();
      return true;
    } catch (e) {
      _topicStatus = TopicStatus.invalid;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _title = "";
    _topicStatus = TopicStatus.writting;
    notifyListeners();
  }
}

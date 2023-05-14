class CreateTodoDTO {
  final String title;
  final DateTime executeDay;
  final DateTime notificationTime;
  final DateTime eventDay;

  CreateTodoDTO({
    required this.title,
    required this.executeDay,
    required this.notificationTime,
    required this.eventDay,
  });
}

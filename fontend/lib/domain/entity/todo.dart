class Todo {
  final String id;
  final String title;
  final DateTime executeDay;
  final DateTime notificationTime;
  final DateTime eventDay;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.executeDay,
    required this.notificationTime,
    required this.completed,
    required this.eventDay,
  });
}

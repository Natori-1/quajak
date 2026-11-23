class Assignment {
  Assignment({
    required this.title,
    required this.subject,
    required this.deadline,
    required this.priority,
    required this.estimatedTime,
    this.memo = '',
    this.completed = false,
    int? notificationId,
  }) : notificationId = notificationId ??
            DateTime.now().microsecondsSinceEpoch.remainder(1000000000);

  String title;
  String subject;
  DateTime deadline;
  String priority;
  String estimatedTime;
  String memo;
  bool completed;

  // 과제별 고유 알림 ID
  int notificationId;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subject': subject,
      'deadline': deadline.toIso8601String(),
      'priority': priority,
      'estimatedTime': estimatedTime,
      'memo': memo,
      'completed': completed,
      'notificationId': notificationId,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      title: json['title'] as String,
      subject: json['subject'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      priority: json['priority'] as String,
      estimatedTime: json['estimatedTime'] as String,
      memo: json['memo'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      notificationId: json['notificationId'] as int?,
    );
  }
}


class Assignment {
  Assignment({
    required this.title,
    required this.subject,
    required this.deadline,
    required this.priority,
    required this.estimatedTime,
    this.memo = '',
    this.completed = false,
  });

  String title;
  String subject;
  DateTime deadline;
  String priority;
  String estimatedTime;
  String memo;
  bool completed;

  // 과제 객체를 저장 가능한 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subject': subject,
      'deadline': deadline.toIso8601String(),
      'priority': priority,
      'estimatedTime': estimatedTime,
      'memo': memo,
      'completed': completed,
    };
  }

  // 저장된 데이터를 과제 객체로 변환
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      title: json['title'] as String,
      subject: json['subject'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      priority: json['priority'] as String,
      estimatedTime: json['estimatedTime'] as String,
      memo: json['memo'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

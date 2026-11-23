
import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onCompletionChanged,
  });

  final Assignment task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onCompletionChanged;

  // 중요도별 글자 색상
  Color _priorityColor(String priority) {
    switch (priority) {
      case '높음':
        return const Color(0xFFC4514B);
      case '보통':
        return const Color(0xFFA47724);
      case '낮음':
        return const Color(0xFF527B49);
      default:
        return const Color(0xFF9B6848);
    }
  }

  // 중요도별 배경 색상
  Color _priorityBackground(String priority) {
    switch (priority) {
      case '높음':
        return const Color(0xFFFBE2DF);
      case '보통':
        return const Color(0xFFFFF0CC);
      case '낮음':
        return const Color(0xFFE4F0DF);
      default:
        return const Color(0xFFF5EDE7);
    }
  }

  // 과제 종류별 색상
  Color _subjectColor(String subject) {
    switch (subject) {
      case '전공':
        return const Color(0xFF8B6B9C);
      case '교양':
        return const Color(0xFF6B91A5);
      default:
        return const Color(0xFF9B6848);
    }
  }

  Color _subjectBackground(String subject) {
    switch (subject) {
      case '전공':
        return const Color(0xFFF0E8F5);
      case '교양':
        return const Color(0xFFE7F0F5);
      default:
        return const Color(0xFFF5EDE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(task.priority);
    final priorityBackground =
        _priorityBackground(task.priority);

    final subjectColor = _subjectColor(task.subject);
    final subjectBackground =
        _subjectBackground(task.subject);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF0E5E0),
        ),
      ),
      child: Row(
        children: [
          // 과제 완료 체크
          Checkbox(
            value: task.completed,
            activeColor: const Color(0xFF9B6848),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (value) {
              onCompletionChanged(value ?? false);
            },
          ),

          // 과제 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 과제명
                Text(
                  task.title,
                  style: TextStyle(
                    color: const Color(0xFF49352D),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 8),

                // 전공 / 교양 / 중요도 / 마감일
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // 과제 종류
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: subjectBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.subject,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: subjectColor,
                        ),
                      ),
                    ),

                    // 중요도
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: priorityBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priority,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: priorityColor,
                        ),
                      ),
                    ),

                    // 마감일
                    // 마감 날짜 및 시간
                    Text(
                      '${task.deadline.month}월 '
                      '${task.deadline.day}일 '
                      '${task.deadline.hour >= 12 ? '오후' : '오전'} '
                      '${(task.deadline.hour % 12 == 0 ? 12 : task.deadline.hour % 12).toString().padLeft(2, '0')}:'
                      '${task.deadline.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFAA9690),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 수정 버튼
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 19,
              color: Color(0xFF9B6848),
            ),
          ),

          // 삭제 버튼
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              size: 19,
              color: Color(0xFFE9857D),
            ),
          ),
        ],
      ),
    );
  }
}

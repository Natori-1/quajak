import 'package:flutter/material.dart';

import '../common/app_theme.dart';
import '../home/task_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.tasks,
  });

  final List<Assignment> tasks;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  // 난이도별 색상
  Color _priorityColor(String priority) {
    switch (priority) {
      case '높음':
        return const Color(0xFFC4514B);
      case '보통':
        return const Color(0xFFA47724);
      case '낮음':
        return const Color(0xFF527B49);
      default:
        return AppColors.brown;
    }
  }

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

  // 과목 구분별 색상
  Color _subjectColor(String subject) {
    switch (subject) {
      case '전공':
        return const Color(0xFF8B6B9C);
      case '교양':
        return const Color(0xFF6B91A5);
      default:
        return AppColors.brown;
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

  // 날짜별 과제 검색
  List<Assignment> _getTasksForDay(DateTime date) {
    return widget.tasks.where((task) {
      return DateUtils.isSameDay(task.deadline, date);
    }).toList();
  }

  // 선택한 날짜의 과제
  List<Assignment> get _selectedTasks {
    return _getTasksForDay(selectedDate);
  }

  // 날짜 이동
  void _changeMonth(int amount) {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + amount,
      );

      selectedDate = DateTime(
        currentMonth.year,
        currentMonth.month,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );

    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );

    final startWeekday = firstDay.weekday % 7;

    return Container(
      color: const Color(0xFFFFF8F5),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 25),
        children: [

          // 제목
          const Text(
            '캘린더',
            style: TextStyle(
              color: Color(0xFF49352D),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            '과제 일정과 메모를 확인해 보세요.',
            style: TextStyle(
              color: Color(0xFFAA9690),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 25),

          // 달력 카드
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFEFD),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFF0E5E0),
              ),
            ),

            child: Column(
              children: [

                // 월 이동
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    IconButton(
                      onPressed: () => _changeMonth(-1),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF9B6848),
                      ),
                    ),

                    Text(
                      '${currentMonth.year}년 ${currentMonth.month}월',
                      style: const TextStyle(
                        color: Color(0xFF49352D),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF9B6848),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 요일
                Row(
                  children: ['일', '월', '화', '수', '목', '금', '토']
                      .map((day) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: day == '일'
                                ? const Color(0xFFE9857D)
                                : day == '토'
                                    ? const Color(0xFF6B91A5)
                                    : const Color(0xFFAA9690),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // 날짜
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: startWeekday + daysInMonth,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 0.78,
                  ),

                  itemBuilder: (context, index) {
                    final day = index - startWeekday + 1;

                    if (day < 1) {
                      return const SizedBox();
                    }

                    final date = DateTime(
                      currentMonth.year,
                      currentMonth.month,
                      day,
                    );

                    final dayTasks = _getTasksForDay(date);

                    final isSelected =
                        DateUtils.isSameDay(selectedDate, date);

                    final isToday =
                        DateUtils.isSameDay(DateTime.now(), date);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },

                      child: Container(
                        margin: const EdgeInsets.all(2),

                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFE9D8)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.brown,
                                  width: 1.3,
                                )
                              : null,
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isToday || isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.brown
                                    : dayTasks.isNotEmpty
                                        ? const Color(0xFF49352D)
                                        : AppColors.dark,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // 과제가 있는 날짜에 색상 점 표시
                            SizedBox(
                              height: 6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: dayTasks
                                    .take(3)
                                    .map((task) {
                                  return Container(
                                    width: 5,
                                    height: 5,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _priorityColor(
                                        task.priority,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // 난이도 범례
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 13,
                  children: [
                    _buildLegend('높음', const Color(0xFFC4514B)),
                    _buildLegend('보통', const Color(0xFFA47724)),
                    _buildLegend('낮음', const Color(0xFF527B49)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 선택 날짜
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                '${selectedDate.month}월 ${selectedDate.day}일 과제',
                style: const TextStyle(
                  color: Color(0xFF49352D),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                '${_selectedTasks.length}개',
                style: const TextStyle(
                  color: Color(0xFFAA9690),
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // 선택 날짜의 과제 목록
          if (_selectedTasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFEFD),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFF0E5E0),
                ),
              ),

              child: const Column(
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 38,
                    color: Color(0xFFD2B9A8),
                  ),

                  SizedBox(height: 10),

                  Text(
                    '등록된 과제가 없어요.',
                    style: TextStyle(
                      color: Color(0xFF49352D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    '다른 날짜를 선택해 보세요!',
                    style: TextStyle(
                      color: Color(0xFFAA9690),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ..._selectedTasks.map((task) {
              return _buildTaskMemoCard(task);
            }),
        ],
      ),
    );
  }

  // 난이도 범례
  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 4),

        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFAA9690),
          ),
        ),
      ],
    );
  }

  // 과제 및 메모 카드
  Widget _buildTaskMemoCard(Assignment task) {
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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 과제명 및 완료 상태
          Row(
            children: [
              Expanded(
                child: Text(
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
              ),

              if (task.completed)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF9B6848),
                  size: 19,
                ),
            ],
          ),

          const SizedBox(height: 10),

          // 전공 / 교양 / 난이도
          Wrap(
            spacing: 7,
            runSpacing: 6,
            children: [

              _buildTag(
                task.subject,
                _subjectColor(task.subject),
                _subjectBackground(task.subject),
              ),

              _buildTag(
                task.priority,
                _priorityColor(task.priority),
                _priorityBackground(task.priority),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(
            color: Color(0xFFF0E5E0),
            height: 1,
          ),

          const SizedBox(height: 12),

          // 메모
          const Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 17,
                color: Color(0xFF9B6848),
              ),

              SizedBox(width: 6),

              Text(
                '과제 메모',
                style: TextStyle(
                  color: Color(0xFF49352D),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            task.memo.trim().isEmpty
                ? '작성된 메모가 없습니다.'
                : task.memo,
            style: const TextStyle(
              color: Color(0xFF88766F),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 태그
  Widget _buildTag(
    String text,
    Color textColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

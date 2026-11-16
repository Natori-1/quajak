import 'package:flutter/material.dart';
import '../common/app_theme.dart';
import '../common/app_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}
class _CalendarPageState extends State<CalendarPage> {
  DateTime currentMonth = DateTime.now();
  int? selectedDay;

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

    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          '캘린더',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month - 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_left),
            ),

            Text(
              '${currentMonth.year}년 ${currentMonth.month}월',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month + 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['일', '월', '화', '수', '목', '금', '토']
              .map((e) => Text(e))
              .toList(),
        ),

        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: startWeekday + daysInMonth,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final day = index - startWeekday + 1;

            if (day < 1) return const SizedBox();

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = day;
                });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selectedDay == day
                      ? AppColors.brown
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: selectedDay == day
                        ? Colors.white
                        : AppColors.dark,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        Text(
          selectedDay == null
              ? '선택한 날짜'
              : '${currentMonth.month}월 $selectedDay일',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        AppCard(
          child: const SizedBox(height: 120),
        ),

        const SizedBox(height: 15),

        AppCard(
          color: AppColors.cream,
          child: const SizedBox(height: 55),
        ),
      ],
    );
  }
}
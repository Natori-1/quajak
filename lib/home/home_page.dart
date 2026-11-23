import 'package:flutter/material.dart';

import '../cookie/cookie_page.dart';
import '../notification/notification_service.dart';

import 'task_management.dart';
import 'task_model.dart';
import 'task_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.tasks,
    required this.onTasksChanged,
  });

  final List<Assignment> tasks;
  final VoidCallback onTasksChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filter = '전체';

  // 과제 추가 및 수정
  Future<void> _openTaskForm({Assignment? task}) async {
    final result = await showModalBottomSheet<Assignment>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskForm(task: task),
    );

    if (!mounted || result == null) return;

    // 수정하는 경우 기존 알림 취소
    if (task != null) {
      await NotificationService.cancelTask(task);
    }

    setState(() {
      if (task == null) {
        widget.tasks.add(result);
      } else {
        final index = widget.tasks.indexOf(task);

        if (index >= 0) {
          widget.tasks[index] = result;
        }
      }
    });

    // 새 마감기한에 맞춰 알림 예약
    await NotificationService.scheduleTask(result);

    // 캘린더 및 데이터 저장 반영
    widget.onTasksChanged();
  }

  // 과제 삭제
  Future<void> _deleteTask(Assignment task) async {
    // 해당 과제 알림 취소
    await NotificationService.cancelTask(task);

    if (!mounted) return;

    setState(() {
      widget.tasks.remove(task);
    });

    widget.onTasksChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('과제를 삭제했습니다.'),
      ),
    );
  }

  // 과제 완료 상태 변경
  
  // 과제 완료 상태 변경
  Future<void> _toggleTask(
    Assignment task,
    bool completed,
  ) async {
    // 오늘 날짜 가져오기
    final now = DateTime.now();

    // 오늘 마감인 과제만 추출
    final todayTasks = widget.tasks.where((item) {
      return item.deadline.year == now.year &&
          item.deadline.month == now.month &&
          item.deadline.day == now.day;
    }).toList();

    // 변경 전 오늘 과제 완료 여부
    final wasTodayCompleted =
        todayTasks.isNotEmpty &&
        todayTasks.every((item) => item.completed);

    setState(() {
      task.completed = completed;
    });

    // 완료 시 알림 취소
    if (completed) {
      await NotificationService.cancelTask(task);
    } else {
      // 완료 취소 시 알림 재예약
      await NotificationService.scheduleTask(task);
    }

    if (!mounted) return;

    // 캘린더에도 완료 상태 반영
    widget.onTasksChanged();

    // 변경 후 오늘 과제 완료 여부
    final updatedTodayTasks = widget.tasks.where((item) {
      return item.deadline.year == now.year &&
          item.deadline.month == now.month &&
          item.deadline.day == now.day;
    }).toList();

    final isTodayCompleted =
        updatedTodayTasks.isNotEmpty &&
        updatedTodayTasks.every((item) => item.completed);

    // 오늘의 모든 과제를 완료했을 때만 포춘쿠키 실행
    if (!wasTodayCompleted && isTodayCompleted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const FortuneCookieDialog();
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),

      body: SafeArea(
        child: TaskManagement(
          tasks: widget.tasks,
          filter: _filter,

          onFilterChanged: (value) {
            setState(() {
              _filter = value;
            });
          },

          onAdd: () => _openTaskForm(),

          onEdit: (task) {
            _openTaskForm(task: task);
          },

          onDelete: _deleteTask,

          onCompletionChanged: _toggleTask,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9B6848),
        foregroundColor: Colors.white,
        onPressed: () => _openTaskForm(),
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}

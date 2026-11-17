import 'package:flutter/material.dart';

import '../cookie/cookie_page.dart';
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

    // 캘린더에도 변경 사항 반영
    widget.onTasksChanged();
  }

  // 과제 삭제
  void _deleteTask(Assignment task) {
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
  void _toggleTask(Assignment task, bool completed) {
    final wasAllCompleted =
        widget.tasks.isNotEmpty &&
        widget.tasks.every((item) => item.completed);

    setState(() {
      task.completed = completed;
    });

    // 캘린더에도 완료 상태 반영
    widget.onTasksChanged();

    final isAllCompleted =
        widget.tasks.isNotEmpty &&
        widget.tasks.every((item) => item.completed);

    // 마지막 과제 완료 시 포춘쿠키 실행
    if (!wasAllCompleted && isAllCompleted) {
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

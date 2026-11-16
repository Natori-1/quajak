
import 'package:flutter/material.dart';
import '../cookie/cookie_page.dart';
import 'task_management.dart';
import 'task_model.dart';
import 'task_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filter = '전체';

  final List<Assignment> _tasks = [];

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
        _tasks.add(result);
      } else {
        final index = _tasks.indexOf(task);

        if (index >= 0) {
          _tasks[index] = result;
        }
      }
    });
  }

  // 과제 삭제
  void _deleteTask(Assignment task) {
    setState(() {
      _tasks.remove(task);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('과제를 삭제했습니다.'),
      ),
    );
  }

  // 과제 완료 상태 변경
// 과제 완료 상태 변경
void _toggleTask(Assignment task, bool completed) {

  // 변경하기 전 모든 과제가 완료되었는지 확인
  final wasAllCompleted =
      _tasks.isNotEmpty &&
      _tasks.every((task) => task.completed);

  setState(() {
    task.completed = completed;
  });

  // 변경 후 모든 과제가 완료되었는지 확인
  final isAllCompleted =
      _tasks.isNotEmpty &&
      _tasks.every((task) => task.completed);

  // 마지막 과제까지 완료된 순간 포춘쿠키 실행
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
          tasks: _tasks,
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

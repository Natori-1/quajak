
import 'package:flutter/material.dart';

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
  void _toggleTask(Assignment task, bool completed) {
    setState(() {
      task.completed = completed;
    });
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


import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskStore extends ChangeNotifier {
  TaskStore._();

  static final TaskStore instance = TaskStore._();

  final List<Assignment> _tasks = [];

  List<Assignment> get tasks => List.unmodifiable(_tasks);

  // 과제 추가
  void addTask(Assignment task) {
    _tasks.add(task);
    notifyListeners();
  }

  // 과제 수정
  void updateTask(Assignment oldTask, Assignment newTask) {
    final index = _tasks.indexOf(oldTask);

    if (index != -1) {
      _tasks[index] = newTask;
      notifyListeners();
    }
  }

  // 과제 삭제
  void deleteTask(Assignment task) {
    _tasks.remove(task);
    notifyListeners();
  }

  // 과제 완료 상태 변경
  void toggleTask(Assignment task, bool completed) {
    task.completed = completed;
    notifyListeners();
  }
}

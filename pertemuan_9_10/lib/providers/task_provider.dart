import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  final List<String> _tasks = [];

  List<String> get tasks => _tasks;

  void addTask(String task) {
    if (task.trim().isEmpty) return;
    _tasks.add(task);
    notifyListeners();
  }

  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }
}
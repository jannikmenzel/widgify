import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String name;
  final DateTime deadline;
  final String priority;
  final List<String> subtasks;

  Task({
    required this.name,
    required this.deadline,
    required this.priority,
    required this.subtasks,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'deadline': deadline.toIso8601String(),
      'priority': priority,
      'subtasks': subtasks,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      deadline: DateTime.parse(json['deadline']),
      priority: json['priority'],
      subtasks: List<String>.from(json['subtasks'] ?? []),
    );
  }
}

Future<List<Task>> loadTasks() async {
  final prefs = await SharedPreferences.getInstance();
  final tasksJson = prefs.getString('tasks');
  if (tasksJson != null) {
    final List<dynamic> decoded = jsonDecode(tasksJson);
    return decoded.map((taskJson) => Task.fromJson(taskJson)).toList();
  }
  return [];
}

Future<void> saveTasks(List<Task> tasks) async {
  final prefs = await SharedPreferences.getInstance();
  final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
  await prefs.setString('tasks', tasksJson);
}

Future<void> deleteTask(Task taskToDelete) async {
  final prefs = await SharedPreferences.getInstance();
  final tasksJson = prefs.getString('tasks');

  if (tasksJson != null) {
    final List<dynamic> decoded = jsonDecode(tasksJson);
    final List<Task> tasks = decoded.map((taskJson) => Task.fromJson(taskJson)).toList();
    tasks.removeWhere((task) => task.name == taskToDelete.name && task.deadline == taskToDelete.deadline);
    await saveTasks(tasks);
  }
}

Color getPriorityColor(String priority) {
  switch (priority) {
    case 'Hoch':
      return Color.fromRGBO(249, 65, 68, 0.6);
    case 'Mittel':
      return Color.fromRGBO(249, 199, 79, 0.6);
    case 'Niedrig':
      return Color.fromRGBO(144, 190, 109, 0.6);
    default:
      return Colors.blue;
  }
}
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DayTask {
  final String module;
  final int ds;
  final String room;

  DayTask({
    required this.module,
    required this.ds,
    required this.room,
  });

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'ds': ds,
      'room': room,
    };
  }

  factory DayTask.fromJson(Map<String, dynamic> json) {
    return DayTask(
      module: json['module'],
      ds: json['ds'],
      room: json['room'],
    );
  }
}

Future<Map<String, List<DayTask>>> loadWeekPlan() async {
  final prefs = await SharedPreferences.getInstance();
  final weekPlanJson = prefs.getString('weekPlan');
  if (weekPlanJson != null) {
    final Map<String, dynamic> decoded = jsonDecode(weekPlanJson);
    return decoded.map((day, tasksJson) {
      final tasks = (tasksJson as List).map((taskJson) => DayTask.fromJson(taskJson)).toList();
      return MapEntry(day, tasks);
    });
  }
  return {
    'Montag': [],
    'Dienstag': [],
    'Mittwoch': [],
    'Donnerstag': [],
    'Freitag': [],
  };
}

Future<void> saveWeekPlan(Map<String, List<DayTask>> weekPlan) async {
  final prefs = await SharedPreferences.getInstance();
  final weekPlanJson = jsonEncode(
    weekPlan.map((day, tasks) {
      return MapEntry(day, tasks.map((task) => task.toJson()).toList());
    }),
  );
  await prefs.setString('weekPlan', weekPlanJson);
}

Future<void> deleteDayTask(String day, DayTask taskToDelete) async {
  final prefs = await SharedPreferences.getInstance();
  final weekPlanJson = prefs.getString('weekPlan');

  if (weekPlanJson != null) {
    final Map<String, dynamic> decoded = jsonDecode(weekPlanJson);
    final Map<String, List<DayTask>> weekPlan = decoded.map((day, tasksJson) {
      final tasks = (tasksJson as List).map((taskJson) => DayTask.fromJson(taskJson)).toList();
      return MapEntry(day, tasks);
    });

    final dayTasks = weekPlan[day];
    if (dayTasks != null) {
      dayTasks.removeWhere((task) =>
      task.module == taskToDelete.module &&
          task.ds == taskToDelete.ds &&
          task.room == taskToDelete.room);
      await saveWeekPlan(weekPlan);
    }
  }
}
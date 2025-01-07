import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgify/pages/main/week_plan/week_plan_utils.dart';

class WeekPlanWidget extends StatefulWidget {
  const WeekPlanWidget({super.key});

  @override
  TodayTasksWidgetState createState() => TodayTasksWidgetState();
}

class TodayTasksWidgetState extends State<WeekPlanWidget> {
  String today = '';

  @override
  void initState() {
    super.initState();
    today = _getToday();
  }

  String _getToday() {
    final now = DateTime.now();
    Intl.defaultLocale = 'de_DE';
    final formatter = DateFormat('EEEE');
    return formatter.format(now);
  }

  Future<Map<String, List<DayTask>>> _loadWeekPlan() async {
    return await loadWeekPlan();
  }

  void _changeDay(bool next) {
    const days = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
    final currentIndex = days.indexOf(today);
    setState(() {
      today = next
          ? days[(currentIndex + 1) % days.length]
          : days[(currentIndex - 1 + days.length) % days.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<DayTask>>>(
      future: _loadWeekPlan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Fehler: ${snapshot.error}'));
        }

        final tasksForToday = snapshot.data?[today] ?? [];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aufgaben für $today',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => _changeDay(false),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () => _changeDay(true),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tasksForToday.isEmpty
                    ? [Text('Keine Aufgaben für heute')]
                    : tasksForToday
                    .map((taskData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        taskData.module,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Raum: ${taskData.room} | DS: ${taskData.ds}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                })
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
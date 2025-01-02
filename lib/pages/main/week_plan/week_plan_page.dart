import 'package:flutter/material.dart';
import 'package:widgify/pages/main/week_plan/week_plan_details_page.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';

import 'week_plan_utils.dart';

class WeekPlanPage extends StatefulWidget {
  const WeekPlanPage({super.key});

  @override
  State<WeekPlanPage> createState() => _WeekPlanPageState();
}

class _WeekPlanPageState extends State<WeekPlanPage> {
  Map<String, List<DayTask>> _weekPlan = {
    'Montag': [],
    'Dienstag': [],
    'Mittwoch': [],
    'Donnerstag': [],
    'Freitag': [],
  };

  @override
  void initState() {
    super.initState();
    _loadWeekPlan();
  }

  Future<void> _loadWeekPlan() async {
    final weekPlan = await loadWeekPlan();
    setState(() {
      _weekPlan = weekPlan;
    });
  }

  Future<void> _saveWeekPlan() async {
    await saveWeekPlan(_weekPlan);
  }

  Future<void> _addTask(String day) async {
    final TextEditingController moduleController = TextEditingController();
    final TextEditingController dsController = TextEditingController();
    final TextEditingController roomController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Neuen Tagespunkt hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: moduleController,
                decoration: const InputDecoration(labelText: 'Modul'),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: dsController,
                decoration: const InputDecoration(labelText: 'Doppelstunde'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'Raum'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                final module = moduleController.text;
                final ds = int.tryParse(dsController.text) ?? 1;
                final room = roomController.text;

                if (module.isNotEmpty && room.isNotEmpty && ds >= 1 && ds <= 10) {
                  final newTask = DayTask(module: module, ds: ds, room: room);
                  setState(() {
                    _weekPlan[day]?.add(newTask);
                  });
                  _saveWeekPlan();
                  Navigator.pop(context);
                }
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetailsPage(String day, List<DayTask> tasks) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeekPlanDetailsPage(
          day: day,
          tasks: tasks,
          onSave: (updatedTasks) {
            setState(() {
              _weekPlan[day] = updatedTasks;
            });
            _saveWeekPlan();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wochenplan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 30.0,
            onPressed: () async {
              String? selectedDay = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Wochentag auswählen'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _weekPlan.keys
                          .map(
                            (day) => ListTile(
                          title: Text(day),
                          onTap: () => Navigator.pop(context, day),
                        ),
                      )
                          .toList(),
                    ),
                  );
                },
              );
              if (selectedDay != null) {
                _addTask(selectedDay);
              }
            },
          ),
        ],
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.pageBackground
            : AppColors.pageBackgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView(
          children: _weekPlan.entries.map((entry) {
            final day = entry.key;
            final tasks = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: InkWell(
                onTap: () => _navigateToDetailsPage(day, tasks),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: AppTypography.headline,
                      ),
                      const SizedBox(height: 8.0),
                      if (tasks.isEmpty)
                        const Text('Keine Tagespunkte hinzugefügt'),
                      for (var task in tasks)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('- ${task.module}, DS: ${task.ds}, Raum: ${task.room}'),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
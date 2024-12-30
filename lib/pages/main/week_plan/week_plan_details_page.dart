import 'package:flutter/material.dart';
import 'package:widgify/styles/colors.dart';
import 'week_plan_utils.dart';

class WeekPlanDetailsPage extends StatefulWidget {
  final String day;
  final List<DayTask> tasks;
  final Function(List<DayTask>) onSave;

  const WeekPlanDetailsPage({
    required this.day,
    required this.tasks,
    required this.onSave,
    super.key,
  });

  @override
  State<WeekPlanDetailsPage> createState() => _WeekPlanDetailsPageState();
}

class _WeekPlanDetailsPageState extends State<WeekPlanDetailsPage> {
  late List<DayTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
  }

  void _deleteTask(DayTask task) {
    setState(() {
      _tasks.remove(task);
    });
    widget.onSave(_tasks);
  }

  void _editTask(DayTask task) {
    final TextEditingController moduleController = TextEditingController(text: task.module);
    final TextEditingController dsController = TextEditingController(text: task.ds.toString());
    final TextEditingController roomController = TextEditingController(text: task.room);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tagespunkt bearbeiten'),
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
                decoration: const InputDecoration(labelText: 'DS (1-10)'),
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
                final updatedTask = DayTask(
                  module: moduleController.text,
                  ds: int.tryParse(dsController.text) ?? 1,
                  room: roomController.text,
                );
                setState(() {
                  final index = _tasks.indexOf(task);
                  if (index != -1) {
                    _tasks[index] = updatedTask;
                  }
                });
                widget.onSave(_tasks);
                Navigator.pop(context);
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.day} - Details'),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.pageBackground
            : AppColors.pageBackgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: _tasks.map((task) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text('${task.module}, DS: ${task.ds}, Raum: ${task.room}'),
                onTap: () => _editTask(task),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTask(task),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
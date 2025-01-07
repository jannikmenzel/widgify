import 'package:flutter/material.dart';
import 'package:widgify/pages/main/tasks/tasks_utils.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key});

  Future<List<Task>> _getAllTasks() async {
    return await loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Fehler: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text('Keine anstehenden Aufgaben gefunden'),
              ),
            ),
          );
        }

        final tasks = snapshot.data!;
        tasks.sort((a, b) => a.deadline.compareTo(b.deadline));

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anstehende Aufgaben',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8.0),
                ...tasks.map((task) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: getPriorityColor(task.priority),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fällig am: ${task.deadline.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(fontSize: 14),
                        ),
                        if (task.subtasks.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Unteraufgaben:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...task.subtasks.map(
                                (subtask) => Text(
                              '- $subtask',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
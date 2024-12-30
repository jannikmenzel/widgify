import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgify/pages/main/tasks/tasks_details_page.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';
import 'tasks_utils.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await loadTasks();
    setState(() {
      _tasks.addAll(loadedTasks);
    });
  }

  Future<void> _saveTasks() async {
    await saveTasks(_tasks);
  }

  Future<void> _addTask() async {
    final TextEditingController nameController = TextEditingController();
    String selectedPriority = 'Mittel';
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Neue Aufgabe hinzufügen'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: SizedBox(
                  width: 400.0,
                  height: 250.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: 'Aufgabenname'),
                      ),
                      const SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setStateDialog(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          selectedDate == null
                              ? 'Datum auswählen'
                              : DateFormat('dd.MM.yyyy').format(selectedDate!),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      // ChoiceChips werden nun untereinander und zentriert angezeigt
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Sorgt für eine saubere Ausrichtung
                        children: [
                          Text(
                            'Priorität:',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // Gleiche Abstände zwischen den Chips
                            children: ['Niedrig', 'Mittel', 'Hoch'].map((
                                priority) {
                              return ChoiceChip(
                                label: Text(priority),
                                selected: selectedPriority == priority,
                                selectedColor: getPriorityColor(priority),
                                onSelected: (_) {
                                  setStateDialog(() {
                                    selectedPriority = priority;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedDate != null) {
                  final newTask = Task(
                    name: nameController.text,
                    deadline: selectedDate!,
                    priority: selectedPriority,
                    progress: 0.0,
                    subtasks: [],
                  );
                  setState(() {
                    _tasks.add(newTask);
                  });
                  _saveTasks();
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

  Future<void> _deleteTask(Task task) async {
    await deleteTask(task);
    setState(() {
      _tasks.remove(task);
    });
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Löschen bestätigen'),
          content: Text(
              'Möchtest du die Aufgabe "${task.name}" wirklich löschen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                _deleteTask(task);
                Navigator.pop(context);
              },
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTaskDetails(Task task, int index) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TaskDetailsPage(
              task: task,
              onSave: (editedTask) {
                setState(() {
                  _tasks[index] = editedTask;
                });
                _saveTasks();
              },
            ),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        _tasks[index] = updatedTask;
      });
      _saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aufgaben'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 30.0,
            onPressed: _addTask,
          ),
        ],
        backgroundColor: Theme
            .of(context)
            .brightness == Brightness.light
            ? AppColors.pageBackground
            : AppColors.pageBackgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: _tasks.isEmpty
            ? Center(
          child: Text('Keine Aufgaben vorhanden'),
        )
            : ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return GestureDetector(
              onTap: () => _navigateToTaskDetails(task, index),
              onLongPress: () => _showDeleteConfirmation(task),
              child: Card(
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              task.name, style: AppTypography.headline),
                          const SizedBox(height: 1.0),
                          Text(
                              'Deadline: ${DateFormat('dd.MM.yyyy').format(
                                  task.deadline)}'),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: LinearProgressIndicator(
                              value: task.progress,
                              backgroundColor: Colors.grey[300],
                              color: getPriorityColor(task.priority),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (task.subtasks.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Teilaufgaben:', style: AppTypography.body),
                                for (var subtask in task.subtasks)
                                  Text('- $subtask'),
                              ],
                            ),
                        ],
                      ),
                      Positioned(
                        right: 8.0,
                        top: 8.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: getPriorityColor(task.priority),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            task.priority,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
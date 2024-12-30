import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/pages/main/tasks/tasks_utils.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final Function(Task) onSave;

  const TaskDetailsPage({
    required this.task,
    required this.onSave,
    super.key,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TextEditingController _nameController;
  late DateTime _deadline;
  late String _priority;
  late List<String> _subtasks;
  late List<TextEditingController> _subtaskControllers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _deadline = widget.task.deadline;
    _priority = widget.task.priority;
    _subtasks = List.from(widget.task.subtasks);
    _subtaskControllers = _subtasks.map((subtask) => TextEditingController(text: subtask)).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _deadline = pickedDate;
      });
    }
  }

  void _addSubtask() {
    if (_subtasks.length < 3) {
      setState(() {
        _subtasks.add('');
        _subtaskControllers.add(TextEditingController());
      });
    }
  }

  void _removeSubtask(int index) {
    if (_subtasks.isNotEmpty) {
      setState(() {
        _subtasks.removeAt(index);
        _subtaskControllers.removeAt(index).dispose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Aufgabendetails bearbeiten',
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Aufgabenname',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Deadline:', style: AppTypography.body),
                  ElevatedButton(
                    onPressed: _updateDeadline,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      DateFormat('dd.MM.yyyy').format(_deadline),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text('Priorität:', style: AppTypography.body),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Niedrig', 'Mittel', 'Hoch'].map((priority) {
                  return ChoiceChip(
                    label: Text(
                      priority,
                    ),
                    selected: _priority == priority,
                    selectedColor: getPriorityColor(priority),
                    onSelected: (_) {
                      setState(() {
                        _priority = priority;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              Text('Teilaufgaben:', style: AppTypography.body),
              const SizedBox(height: 8.0),
              for (int i = 0; i < _subtaskControllers.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _subtaskControllers[i],
                          onChanged: (text) {
                            setState(() {
                              _subtasks[i] = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Teilaufgabe ${i + 1}',
                            hintText: 'Optional',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () => _removeSubtask(i),
                      ),
                    ],
                  ),
                ),
              if (_subtasks.length < 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: _addSubtask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Teilaufgabe hinzufügen',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 25.0),
        child: ElevatedButton(
          onPressed: () {
            final updatedTask = Task(
              name: _nameController.text,
              deadline: _deadline,
              priority: _priority,
              progress: widget.task.progress,
              subtasks: _subtasks,
            );
            widget.onSave(updatedTask);
            Navigator.pop(context, updatedTask);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: Text(
            'Speichern',
          ),
        ),
      ),
    );
  }
}
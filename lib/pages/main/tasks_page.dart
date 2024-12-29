import 'package:flutter/material.dart';
import 'package:widgify/styles/typography.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Tasks', style: AppTypography.body),
      ),
    );
  }
}
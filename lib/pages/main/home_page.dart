import 'package:flutter/material.dart';
import 'package:widgify/components/widgets/modules_widget.dart';
import 'package:widgify/components/widgets/week_plan_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView(
          children: [
            ExamCardWidget(),
            GradeCardWidget(),
            TodayTasksWidget()
          ],
        ),
      ),
    );
  }
}
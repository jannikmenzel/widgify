import 'package:flutter/material.dart';
import 'package:widgify/styles/typography.dart';

class WeekPlanPage extends StatelessWidget {
  const WeekPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Wochenplan', style: AppTypography.body),
      ),
    );
  }
}
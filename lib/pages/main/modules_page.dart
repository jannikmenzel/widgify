import 'package:flutter/material.dart';
import 'package:widgify/styles/typography.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Module', style: AppTypography.body),
      ),
    );
  }
}
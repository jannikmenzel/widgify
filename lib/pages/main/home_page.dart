import 'package:flutter/material.dart';
import 'package:widgify/styles/typography.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Startseite', style: AppTypography.body),
      ),
    );
  }
}
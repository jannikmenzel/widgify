import 'package:flutter/material.dart';
import 'package:widgify/styles/typography.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Musik', style: AppTypography.body),
      ),
    );
  }
}
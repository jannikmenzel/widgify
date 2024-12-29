import 'package:flutter/material.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/styles/typography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Benachrichtigungen',
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Center(
        child: Text(
            'Benachrichtigungen',
            style: AppTypography.body
        ),
      ),
    );
  }
}
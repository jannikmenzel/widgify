import 'package:flutter/material.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/styles/typography.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account',
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Center(child: Text('Account', style: AppTypography.body)),
    );
  }
}
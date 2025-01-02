import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/pages/sub/account_page.dart';
import 'package:widgify/pages/sub/themes_page.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';
import 'package:widgify/utils/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Einstellungen',
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingOption(
                    context: context,
                    icon: Icons.person,
                    label: 'Account',
                    page: AccountPage(),
                  ),
                  _buildSettingOption(
                    context: context,
                    icon: Icons.notifications,
                    label: 'Benachrichtigungen',
                    onPressed: () {
                      // ... To Do
                    },
                  ),
                  _buildSettingOption(
                    context: context,
                    icon: Icons.privacy_tip,
                    label: 'Berechtigungen',
                    onPressed: () {
                      // ... To Do
                    },
                  ),
                  const SizedBox(height: 25.0),
                  _buildSettingOption(
                    context: context,
                    icon: Icons.edit,
                    label: 'Bearbeitungsmodus',
                    onPressed: () {
                      // ... To Do
                    },
                  ),
                  _buildSettingOption(
                    context: context,
                    icon: Icons.color_lens,
                    label: 'Themes',
                    page: ThemesPage(),
                  ),
                  _buildSettingOption(
                    context: context,
                    icon: Icons.dark_mode,
                    label: 'Darkmode',
                    onPressed: () {
                      // Darkmode umschalten
                      Provider.of<ThemeProviderDarkmode>(context, listen: false)
                          .toggleDarkMode();
                    },
                  ),
                  const SizedBox(height: 25.0),
                  _buildSettingOption(
                    context: context,
                    icon: Icons.support,
                    label: 'Support',
                    onPressed: () {
                      // ... To Do
                    },
                  ),
                  _buildSettingOption(
                    context: context,
                    icon: Icons.logout,
                    label: 'Abmelden',
                    onPressed: () {
                      // ... To Do
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '© 2024 Widgify. Alle Rechte vorbehalten.',
                textAlign: TextAlign.center,
                style: AppTypography.subtext
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onPressed,
  }) {
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.pageBackground
        : AppColors.pageBackgroundDark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 30.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed ?? () {
                  if (page != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 0.3,
                      color: borderColor,
                    ),
                  ),
                  child: Text(
                    label,
                    style: AppTypography.body,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
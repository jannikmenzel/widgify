import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/utils/widget_preferences_provider.dart';

class CustomizeHomePage extends StatelessWidget {
  const CustomizeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final preferencesProvider = Provider.of<WidgetPreferencesProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Widgets anpassen",
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Klausuren"),
              value: preferencesProvider.showModule1,
              onChanged: (bool value) {
                preferencesProvider.toggleModule1(value);
              },
            ),
            SwitchListTile(
              title: const Text("Noten"),
              value: preferencesProvider.showModule2,
              onChanged: (bool value) {
                preferencesProvider.toggleModule2(value);
              },
            ),
            SwitchListTile(
              title: const Text("Wochenplan"),
              value: preferencesProvider.showWeekPlan,
              onChanged: (bool value) {
                preferencesProvider.toggleWeekPlan(value);
              },
            ),
            SwitchListTile(
              title: const Text("Aufgaben"),
              value: preferencesProvider.showTaskWidget,
              onChanged: (bool value) {
                preferencesProvider.toggleTaskWidget(value);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 25.0),
        child: ElevatedButton(
          onPressed: () async {
            await preferencesProvider.savePreferences();
            if (context.mounted) {
              Navigator.pop(context);
            }
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgify/components/widgets/modules_widget.dart';
import 'package:widgify/components/widgets/tasks_widget.dart';
import 'package:widgify/components/widgets/week_plan_widget.dart';
import 'package:widgify/pages/main/home_page/customize_home_page.dart';
import 'package:widgify/utils/widget_preferences_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final preferencesProvider = Provider.of<WidgetPreferencesProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (preferencesProvider.showModule1) ModulesWidget1(),
                if (preferencesProvider.showModule2) ModulesWidget2(),
                if (preferencesProvider.showWeekPlan) WeekPlanWidget(),
                if (preferencesProvider.showTaskWidget) TaskWidget(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: MediaQuery.of(context).size.width * 0.15,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CustomizeHomePage()),
                  );
                },
                child: const Text(
                  "Anpassen",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
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
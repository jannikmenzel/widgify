import 'package:shared_preferences/shared_preferences.dart';

class SelectedWidget {
  static const String keyShowModule1 = 'showModule1';
  static const String keyShowModule2 = 'showModule2';
  static const String keyShowWeekPlan = 'showWeekPlan';
  static const String keyShowTaskWidget = 'showTaskWidget';

  static Future<void> saveWidgetPreferences({
    required bool showModule1,
    required bool showModule2,
    required bool showWeekPlan,
    required bool showTaskWidget,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(keyShowModule1, showModule1);
    await prefs.setBool(keyShowModule2, showModule2);
    await prefs.setBool(keyShowWeekPlan, showWeekPlan);
    await prefs.setBool(keyShowTaskWidget, showTaskWidget);
  }

  static Future<Map<String, bool>> loadWidgetPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool showModule1 = prefs.getBool(keyShowModule1) ?? true;
    final bool showModule2 = prefs.getBool(keyShowModule2) ?? true;
    final bool showWeekPlan = prefs.getBool(keyShowWeekPlan) ?? true;
    final bool showTaskWidget = prefs.getBool(keyShowTaskWidget) ?? true;

    return {
      keyShowModule1: showModule1,
      keyShowModule2: showModule2,
      keyShowWeekPlan: showWeekPlan,
      keyShowTaskWidget: showTaskWidget,
    };
  }
}
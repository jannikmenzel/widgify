import 'package:flutter/material.dart';
import 'package:widgify/pages/main/home_page/home_page_utils.dart';

class WidgetPreferencesProvider extends ChangeNotifier {
  bool showModule1 = true;
  bool showModule2 = true;
  bool showWeekPlan = true;
  bool showTaskWidget = true;

  Future<void> loadPreferences() async {
    final preferences = await SelectedWidget.loadWidgetPreferences();
    showModule1 = preferences[SelectedWidget.keyShowModule1] ?? true;
    showModule2 = preferences[SelectedWidget.keyShowModule2] ?? true;
    showWeekPlan = preferences[SelectedWidget.keyShowWeekPlan] ?? true;
    showTaskWidget = preferences[SelectedWidget.keyShowTaskWidget] ?? true;
    notifyListeners();
  }

  Future<void> savePreferences() async {
    await SelectedWidget.saveWidgetPreferences(
      showModule1: showModule1,
      showModule2: showModule2,
      showWeekPlan: showWeekPlan,
      showTaskWidget: showTaskWidget,
    );
    notifyListeners();
  }

  void toggleModule1(bool value) {
    showModule1 = value;
    notifyListeners();
  }

  void toggleModule2(bool value) {
    showModule2 = value;
    notifyListeners();
  }

  void toggleWeekPlan(bool value) {
    showWeekPlan = value;
    notifyListeners();
  }

  void toggleTaskWidget(bool value) {
    showTaskWidget = value;
    notifyListeners();
  }
}
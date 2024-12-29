import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgify/styles/colors.dart';

class ThemeProviderDarkmode with ChangeNotifier {
  bool _isDarkMode;

  ThemeProviderDarkmode({required bool isDarkMode}) : _isDarkMode = isDarkMode;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _updatePrefs();
    notifyListeners();
  }

  Future<void> _updatePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }
}

class ThemeProviderPrimary extends ChangeNotifier {
  Color get primaryColor => AppColors.primary;

  Future<void> loadPrimaryColor() async {
    final prefs = await SharedPreferences.getInstance();
    int? red = prefs.getInt('primaryColorRed');
    int? green = prefs.getInt('primaryColorGreen');
    int? blue = prefs.getInt('primaryColorBlue');
    int? alpha = prefs.getInt('primaryColorAlpha');

    if (red != null && green != null && blue != null && alpha != null) {
      AppColors.primary = Color.fromARGB(alpha, red, green, blue);
    } else {
      AppColors.primary = AppColors.primary;
    }

    notifyListeners();
  }

  Future<void> setPrimaryColor(Color newColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColorRed', (newColor.r * 255).toInt());
    await prefs.setInt('primaryColorGreen', (newColor.g * 255).toInt());
    await prefs.setInt('primaryColorBlue', (newColor.b * 255).toInt());
    await prefs.setInt('primaryColorAlpha', (newColor.a * 255).toInt());
    AppColors.primary = newColor;
    notifyListeners();
  }
}
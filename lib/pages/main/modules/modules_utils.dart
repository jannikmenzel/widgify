import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules_page.dart';

//Geht noch nicht

// Speichert die Liste der Module in SharedPreferences
Future<void> saveModules(List<Module> modules) async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = jsonEncode(modules.map((module) => module.toJson()).toList());
  await prefs.setString('modules', modulesJson);
}

// Lädt die Liste der Module aus SharedPreferences
Future<List<Module>> loadModules() async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = prefs.getString('modules');
  if (modulesJson != null) {
    final List<dynamic> decoded = jsonDecode(modulesJson);
    return decoded.map((moduleJson) => Module.fromJson(moduleJson)).toList();
  }
  return [];
}

// Löscht ein Modul aus SharedPreferences
Future<void> deleteModule(Module moduleToDelete) async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = prefs.getString('modules');

  if (modulesJson != null) {
    final List<dynamic> decoded = jsonDecode(modulesJson);
    final List<Module> modules = decoded.map((moduleJson) => Module.fromJson(moduleJson)).toList();
    modules.removeWhere((module) =>
    module.name == moduleToDelete.name && module.code == moduleToDelete.code);
    await saveModules(modules);
  }
}

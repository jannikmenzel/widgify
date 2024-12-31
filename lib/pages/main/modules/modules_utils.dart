import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Module {
  final String name;
  final String code;
  final String dozent;
  final String raum;
  final String ort;
  final String kontakt;
  final String link;
  final int lp;
  final Color color;
  final List<String> klausuren;
  final List<String> noten;

  Module({
    required this.name,
    required this.code,
    required this.dozent,
    required this.raum,
    required this.ort,
    required this.kontakt,
    required this.link,
    required this.lp,
    required this.color,
    required this.klausuren,
    required this.noten,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'dozent': dozent,
      'raum': raum,
      'ort': ort,
      'kontakt': kontakt,
      'link': link,
      'lp': lp,
      'color': color.value,
      'klausuren': klausuren,
      'noten': noten,
    };
  }

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      name: json['name'],
      code: json['code'],
      dozent: json['dozent'],
      raum: json['raum'],
      ort: json['ort'],
      kontakt: json['kontakt'],
      link: json['link'],
      lp: json['lp'],
      color: Color(json['color']),
      klausuren: List<String>.from(json['klausuren'] ?? []),
      noten: List<String>.from(json['noten'] ?? []),
    );
  }
}

Future<List<Module>> loadModules() async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = prefs.getString('modules');
  if (modulesJson != null) {
    final List<dynamic> decoded = jsonDecode(modulesJson);
    return decoded.map((moduleJson) => Module.fromJson(moduleJson)).toList();
  }
  return [];
}

Future<void> saveModules(List<Module> modules) async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = jsonEncode(modules.map((module) => module.toJson()).toList());
  await prefs.setString('modules', modulesJson);
}

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
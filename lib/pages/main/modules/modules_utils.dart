import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Modules {
  final String name;
  final String code;
  final String lecturer;
  final String room;
  final String contact;
  final int lp;
  final Color color;
  final List<String> exams;
  final List<String> grades;

  Modules({
    required this.name,
    required this.code,
    required this.lecturer,
    required this.room,
    required this.contact,
    required this.lp,
    required this.color,
    required this.exams,
    required this.grades,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'dozent': lecturer,
      'raum': room,
      'kontakt': contact,
      'lp': lp,
      'color': {
        'r': color.r,
        'g': color.g,
        'b': color.b,
        'a': color.a,
      },
      'klausuren': exams,
      'noten': grades,
    };
  }

  factory Modules.fromJson(Map<String, dynamic> json) {
    return Modules(
      name: json['name'],
      code: json['code'],
      lecturer: json['dozent'],
      room: json['raum'],
      contact: json['kontakt'],
      lp: json['lp'],
      color: Color.fromRGBO(
        (json['color']['r'] * 255).toInt(),
        (json['color']['g'] * 255).toInt(),
        (json['color']['b'] * 255).toInt(),
        json['color']['a'],
      ),
      exams: List<String>.from(json['klausuren'] ?? []),
      grades: List<String>.from(json['noten'] ?? []),
    );
  }
}

Future<List<Modules>> loadModules() async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = prefs.getString('modules');
  if (modulesJson != null) {
    final List<dynamic> decoded = jsonDecode(modulesJson);
    return decoded.map((moduleJson) => Modules.fromJson(moduleJson)).toList();
  }
  return [];
}

Future<void> saveModules(List<Modules> modules) async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = jsonEncode(modules.map((module) => module.toJson()).toList());
  await prefs.setString('modules', modulesJson);
}

Future<void> deleteModule(Modules moduleToDelete) async {
  final prefs = await SharedPreferences.getInstance();
  final modulesJson = prefs.getString('modules');

  if (modulesJson != null) {
    final List<dynamic> decoded = jsonDecode(modulesJson);
    final List<Modules> modules = decoded.map((moduleJson) => Modules.fromJson(moduleJson)).toList();
    modules.removeWhere((module) =>
    module.name == moduleToDelete.name && module.code == moduleToDelete.code);
    await saveModules(modules);
  }
}
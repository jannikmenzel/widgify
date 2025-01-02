import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgify/pages/main/modules/modules_details_page.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';

import 'modules_utils.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({super.key});

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  List<Modules> _modules = [];
  Color selectedColor = Color(0xFFf94144);

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    final prefs = await SharedPreferences.getInstance();
    final modulesString = prefs.getString('modules');
    if (modulesString != null) {
      final List<dynamic> modulesJson = jsonDecode(modulesString);
      setState(() {
        _modules = modulesJson.map((json) => Modules.fromJson(json)).toList();
      });
    } else {
      final loadedModules = await loadModules();
      setState(() {
        _modules = loadedModules;
      });
    }
  }

  Future<void> _saveModules() async {
    final prefs = await SharedPreferences.getInstance();
    final modulesJson = _modules.map((module) => module.toJson()).toList();
    await prefs.setString('modules', jsonEncode(modulesJson));
  }

  @override
  void dispose() {
    _saveModules();
    super.dispose();
  }

  Future<void> _addModule() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    final TextEditingController lecturerController = TextEditingController();
    final TextEditingController contactController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    final TextEditingController lpController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Neues Modul hinzufügen'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Modulname'),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: codeController,
                            decoration: const InputDecoration(labelText: 'Code'),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () async {
                            final Color? pickedColor =
                            await _showColorPicker(context, selectedColor);
                            if (pickedColor != null) {
                              setDialogState(() {
                                selectedColor = pickedColor;
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: selectedColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: lecturerController,
                      decoration: const InputDecoration(labelText: 'Dozent'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(labelText: 'Raum'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: contactController,
                      decoration: const InputDecoration(labelText: 'Kontakt Dozent'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: lpController,
                      decoration: const InputDecoration(labelText: 'Leistungspunkte (LP)'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        codeController.text.isNotEmpty) {
                      final newModule = Modules(
                        name: nameController.text,
                        code: codeController.text,
                        lecturer: lecturerController.text,
                        room: roomController.text,
                        contact: contactController.text,
                        lp: int.tryParse(lpController.text) ?? 0,
                        color: selectedColor,
                        exams: [],
                        grades: [],
                      );
                      setState(() {
                        _modules.add(newModule);
                        selectedColor = selectedColor;
                      });
                      _saveModules();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Hinzufügen'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<Color?> _showColorPicker(BuildContext context, Color currentColor) async {
    return await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Farbe auswählen'),
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _colorOption(Color(0xFFf94144), setState, currentColor),
                    _colorOption(Color(0xFFf9844a), setState, currentColor),
                    _colorOption(Color(0xFFf9c74f), setState, currentColor),
                    _colorOption(Color(0xFF90be6d), setState, currentColor),
                    _colorOption(Color(0xFF43aa8b), setState, currentColor),
                    _colorOption(Color(0xFF4d908e), setState, currentColor),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _colorOption(Color color, StateSetter setState, Color currentColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentColor = color;
        });
        Navigator.pop(context, color);
      },
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Future<void> _deleteModule(Modules module) async {
    setState(() {
      _modules.remove(module);
    });
    _saveModules(); // Änderungen speichern
  }

  void _showDeleteConfirmation(Modules module) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Löschen bestätigen'),
          content: Text('Möchtest du das Modul "${module.name}" wirklich löschen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                _deleteModule(module);
                Navigator.pop(context);
              },
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 30.0,
            onPressed: _addModule,
          ),
        ],
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.pageBackground
            : AppColors.pageBackgroundDark,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: _modules.isEmpty
            ? Center(
          child: Text('Keine Module vorhanden'),
        )
            : ListView.builder(
          itemCount: _modules.length,
          itemBuilder: (context, index) {
            final module = _modules[index];
            return GestureDetector(
              onTap: () async {
                final updatedModule = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModuleDetailsPage(
                      module: module,
                      onSave: (module) {},
                    ),
                  ),
                );
                if (updatedModule != null) {
                  setState(() {
                    _modules[index] = updatedModule;
                  });
                  _saveModules();
                }
              },
              onLongPress: () => _showDeleteConfirmation(module),
              child: Card(
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(module.name, style: AppTypography.headline),
                              const SizedBox(width: 8.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: module.color,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  module.code,
                                ),
                              ),
                              Expanded(child: Container()),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${module.lp} LP',
                                  style: AppTypography.body
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text('Dozent: ${module.lecturer}', style: AppTypography.body.copyWith(fontSize: 14)),
                          Text('Raum: ${module.room}', style: AppTypography.body.copyWith(fontSize: 14)),
                          Text('Kontakt: ${module.contact}', style: AppTypography.body.copyWith(fontSize: 14)),
                          const Divider(
                            thickness: 2.0,
                            height: 20.0,
                          ),
                          if (module.exams.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Klausur:', style: AppTypography.body),
                                for (var klausur in module.exams)
                                  Text('Klausur am $klausur'),
                              ],
                            ),
                          const SizedBox(height: 8.0),
                          if (module.grades.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Note:', style: AppTypography.body),
                                for (var note in module.grades)
                                  Text(note),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
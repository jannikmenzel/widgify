import 'package:flutter/material.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';
import 'modules_utils.dart';
import 'package:widgify/pages/main/modules/modules_details_page.dart';

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
      'color': color.value, // Speichern als Integer (ARGB-Wert)
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
      color: Color(json['color']), // Rückumwandlung von Integer-Wert zu Color
      klausuren: List<String>.from(json['klausuren'] ?? []),
      noten: List<String>.from(json['noten'] ?? []),
    );
  }
}

  copyWith({
    required String name,
    required String code,
    required String dozent,
    required String raum,
    required String ort,
    required String kontakt,
    required String link,
    required int lp,
    required Color color,
    required String klausur,
    required String note
  }) {}


class ModulesPage extends StatefulWidget {
  const ModulesPage({super.key});

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  List<Module> _modules = []; // Liste der Module
  Color selectedColor = Colors.blue; // Standardfarbe

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    final loadedModules = await loadModules();
    setState(() {
      _modules = loadedModules;
    });
  }

  Future<void> _saveModules() async {
    await saveModules(_modules);
  }

  @override
  void dispose() {
    _saveModules();
    super.dispose();
  }

  Future<void> _addModule() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    final TextEditingController dozentController = TextEditingController();
    final TextEditingController ortController = TextEditingController();
    final TextEditingController kontaktController = TextEditingController();
    final TextEditingController raumController = TextEditingController();
    final TextEditingController linkController = TextEditingController();
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
                              // Lokalen Zustand im Dialog aktualisieren
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
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: dozentController,
                      decoration: const InputDecoration(labelText: 'Dozent'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: raumController,
                      decoration: const InputDecoration(labelText: 'Raum'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: ortController,
                      decoration: const InputDecoration(labelText: 'Ort'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: kontaktController,
                      decoration: const InputDecoration(labelText: 'Kontakt Dozent'),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(labelText: 'Link'),
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
                      final newModule = Module(
                        name: nameController.text,
                        code: codeController.text,
                        dozent: dozentController.text,
                        raum: raumController.text,
                        ort: ortController.text,
                        kontakt: kontaktController.text,
                        link: linkController.text,
                        lp: int.tryParse(lpController.text) ?? 0,
                        color: selectedColor,
                        klausuren: [],
                        noten: [],
                      );
                      setState(() {
                        _modules.add(newModule); // Modul zur Liste hinzufügen
                        selectedColor = selectedColor; // Globale Farbe aktualisieren
                      });
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
                    _colorOption(Colors.red, setState, currentColor),
                    _colorOption(Colors.green, setState, currentColor),
                    _colorOption(Colors.blue, setState, currentColor),
                    _colorOption(Colors.yellow, setState, currentColor),
                    _colorOption(Colors.orange, setState, currentColor),
                    _colorOption(Colors.purple, setState, currentColor),
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
          currentColor = color;  // Die Farbe wird sofort im Dialog aktualisiert
        });
        Navigator.pop(context, color);  // Gibt die ausgewählte Farbe zurück und schließt den Dialog
      },
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> _deleteModule(Module module) async {
    setState(() {
      _modules.remove(module);
    });
  }

  void _showDeleteConfirmation(Module module) {
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
            onPressed: _addModule,
          ),
        ],
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.pageBackground
            : AppColors.pageBackgroundDark,
      ),
      body: _modules.isEmpty
          ? const Center(child: Text('Keine Module vorhanden'))
          : ListView.builder(
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          final module = _modules[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          module.name,
                          style: const TextStyle(fontSize: 16.0), // Optional: Schriftgröße anpassen
                        ),
                        const SizedBox(height: 4.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: module.color, // Verwende die Modulfarbe
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            module.code,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${module.lp} LP',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dozent: ${module.dozent}'),
                  Text('Raum: ${module.raum}'),
                  Text('Kontakt: ${module.kontakt}'),
                  const Divider(
                    thickness: 2.0,
                    height: 20.0,
                  ),
                  if (module.klausuren.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Klausur:', style: AppTypography.body),
                        for (var klausur in module.klausuren)
                          Text('Klausur am $klausur'),
                      ],
                    ),
                  const SizedBox(height: 8.0),
                  if (module.noten.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Note:', style: AppTypography.body),
                        for (var note in module.noten)
                          Text('$note'),
                      ],
                    ),
                ],
              ),
              onLongPress: () => _showDeleteConfirmation(module),
              onTap: () async {
                final updatedModule = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModuleDetailsPage(module: module, onSave: (Module ) {  },),
                  ),
                );
                if (updatedModule != null) {
                  setState(() {
                    _modules[index] = updatedModule;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';
import 'modules_utils.dart';

class ModuleDetailsPage extends StatefulWidget {
  final Module module;
  final Function(Module) onSave;

  const ModuleDetailsPage({
    required this.module,
    required this.onSave,
    super.key,
  });

  @override
  State<ModuleDetailsPage> createState() => _ModuleDetailsPageState();
}

class _ModuleDetailsPageState extends State<ModuleDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _dozentController;
  late TextEditingController _raumController;
  late TextEditingController _ortController;
  late TextEditingController _kontaktController;
  late TextEditingController _linkController;
  late TextEditingController _lpController;
  late Color _color;
  late List<String> _klausuren;
  late List<TextEditingController> _klausurControllers;
  late List<String> _noten;
  late List<TextEditingController> _noteControllers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.module.name);
    _codeController = TextEditingController(text: widget.module.code);
    _dozentController = TextEditingController(text: widget.module.dozent);
    _raumController = TextEditingController(text: widget.module.raum);
    _ortController = TextEditingController(text: widget.module.ort);
    _kontaktController = TextEditingController(text: widget.module.kontakt);
    _linkController = TextEditingController(text: widget.module.link);
    _lpController = TextEditingController(text: widget.module.lp.toString());
    _color = widget.module.color;
    _klausuren = List.from(widget.module.klausuren);
    _klausurControllers =
        _klausuren
            .map((klausur) => TextEditingController(text: klausur))
            .toList();
    _noten = List.from(widget.module.noten);
    _noteControllers =
        _noten.map((note) => TextEditingController(text: note)).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _dozentController.dispose();
    _raumController.dispose();
    _ortController.dispose();
    _kontaktController.dispose();
    _linkController.dispose();
    _lpController.dispose();
    for (var controller in _klausurControllers) {
      controller.dispose();
    }
    for (var controller in _noteControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addklausur() {
    if (_klausuren.length < 6) {
      setState(() {
        _klausuren.add('');
        _klausurControllers.add(TextEditingController());
      });
    }
  }

  void _removeklausur(int index) {
    if (_klausuren.isNotEmpty) {
      setState(() {
        _klausuren.removeAt(index);
        _klausurControllers.removeAt(index).dispose();
      });
    }
  }

  void _addnote() {
    if (_noten.length < 6) {
      setState(() {
        _noten.add('');
        _noteControllers.add(TextEditingController());
      });
    }
  }

  void _removenote(int index) {
    if (_noten.isNotEmpty) {
      setState(() {
        _noten.removeAt(index);
        _noteControllers.removeAt(index).dispose();
      });
    }
  }

  // Farbe
  Future<void> _pickColor() async {
    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Farbe auswählen'),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _colorOption(Colors.red),
                SizedBox(width: 8),
                _colorOption(Colors.green),
                SizedBox(width: 8),
                _colorOption(Colors.blue),
                SizedBox(width: 8),
                _colorOption(Colors.yellow),
                SizedBox(width: 8),
                _colorOption(Colors.orange),
                SizedBox(width: 8),
                _colorOption(Colors.purple),
              ],
            ),
          ),
        );
      },
    );

    if (selectedColor != null) {
      setState(() {
        _color = selectedColor;
      });
    }
  }


  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, color),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul bearbeiten'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Modulname'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(labelText: 'Code'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: _pickColor,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _dozentController,
                decoration: const InputDecoration(labelText: 'Dozent'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _raumController,
                decoration: const InputDecoration(labelText: 'Raum'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _ortController,
                decoration: const InputDecoration(labelText: 'Ort'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _kontaktController,
                decoration: const InputDecoration(labelText: 'Kontakt'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _linkController,
                decoration: const InputDecoration(labelText: 'Link'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _lpController,
                decoration: const InputDecoration(
                    labelText: 'Leistungspunkte (LP)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              Text('Klausur:', style: AppTypography.body),
              const SizedBox(height: 8.0),
              for (int i = 0; i < _klausurControllers.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _klausuren[i] = DateFormat('dd.MM.yyyy').format(
                                    selectedDate);
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              _klausuren[i].isEmpty
                                  ? 'Datum auswählen'
                                  : _klausuren[i],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () => _removeklausur(i),
                      ),
                    ],
                  ),
                ),
              if (_klausuren.length < 6)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: _addklausur,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Klausur hinzufügen'),
                  ),
                ),
              const SizedBox(height: 16.0),
              Text('Note:', style: AppTypography.body),
              const SizedBox(height: 8.0),
              for (int i = 0; i < _noteControllers.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteControllers[i],
                          onChanged: (text) {
                            setState(() {
                              _noten[i] = text;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Note auswählen',
                            hintText: 'Optional',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () => _removenote(i),
                      ),
                    ],
                  ),
                ),
              if (_noten.length < 6)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: _addnote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Note hinzufügen'),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            final updatedModule = Module(
              name: _nameController.text,
              code: _codeController.text,
              dozent: _dozentController.text,
              raum: _raumController.text,
              ort: _ortController.text,
              kontakt: _kontaktController.text,
              link: _linkController.text,
              lp: int.tryParse(_lpController.text) ?? 0,
              color: _color,
              klausuren: _klausuren,
              noten: _noten,
            );
            widget.onSave(updatedModule);
            Navigator.pop(context, updatedModule);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: const Text('Speichern'),
        ),
      ),
    );
  }
}

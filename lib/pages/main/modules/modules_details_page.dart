import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';

import 'modules_utils.dart';

class ModuleDetailsPage extends StatefulWidget {
  final Modules module;
  final Function(Modules) onSave;

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
  late TextEditingController _lecturerController;
  late TextEditingController _roomController;
  late TextEditingController _contactController;
  late TextEditingController _lpController;
  late Color _color;
  late List<String> _exams;
  late List<TextEditingController> _examsController;
  late List<String> _grades;
  late List<TextEditingController> _gradesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.module.name);
    _codeController = TextEditingController(text: widget.module.code);
    _lecturerController = TextEditingController(text: widget.module.lecturer);
    _roomController = TextEditingController(text: widget.module.room);
    _contactController = TextEditingController(text: widget.module.contact);
    _lpController = TextEditingController(text: widget.module.lp.toString());
    _color = widget.module.color;
    _exams = List.from(widget.module.exams);
    _examsController =
        _exams
            .map((klausur) => TextEditingController(text: klausur))
            .toList();
    _grades = List.from(widget.module.grades);
    _gradesController =
        _grades.map((note) => TextEditingController(text: note)).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _lecturerController.dispose();
    _roomController.dispose();
    _contactController.dispose();
    _lpController.dispose();
    for (var controller in _examsController) {
      controller.dispose();
    }
    for (var controller in _gradesController) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addExam() {
    if (_exams.length < 6) {
      setState(() {
        _exams.add('');
        _examsController.add(TextEditingController());
      });
    }
  }

  void _removeExam(int index) {
    if (_exams.isNotEmpty) {
      setState(() {
        _exams.removeAt(index);
        _examsController.removeAt(index).dispose();
      });
    }
  }

  void _addGrade() {
    if (_grades.length < 6) {
      setState(() {
        _grades.add('');
        _gradesController.add(TextEditingController());
      });
    }
  }

  void _removeGrade(int index) {
    if (_grades.isNotEmpty) {
      setState(() {
        _grades.removeAt(index);
        _gradesController.removeAt(index).dispose();
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
                _colorOption(Color(0xFFf94144)),
                SizedBox(width: 8),
                _colorOption(Color(0xFFf9844a)),
                SizedBox(width: 8),
                _colorOption(Color(0xFFf9c74f)),
                SizedBox(width: 8),
                _colorOption(Color(0xFF90be6d)),
                SizedBox(width: 8),
                _colorOption(Color(0xFF43aa8b)),
                SizedBox(width: 8),
                _colorOption(Color(0xFF4d908e)),
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
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _lecturerController,
                decoration: const InputDecoration(labelText: 'Dozent'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Raum'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Kontakt'),
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
              for (int i = 0; i < _examsController.length; i++)
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
                                _exams[i] = DateFormat('dd.MM.yyyy').format(
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
                              _exams[i].isEmpty
                                  ? 'Datum auswählen'
                                  : _exams[i],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () => _removeExam(i),
                      ),
                    ],
                  ),
                ),
              if (_exams.length < 6)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: _addExam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Klausur hinzufügen'),
                  ),
                ),
              const SizedBox(height: 16.0),
              Text('Note:', style: AppTypography.body),
              const SizedBox(height: 8.0),
              for (int i = 0; i < _gradesController.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _gradesController[i],
                          onChanged: (text) {
                            setState(() {
                              _grades[i] = text;
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
                        onPressed: () => _removeGrade(i),
                      ),
                    ],
                  ),
                ),
              if (_grades.length < 6)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: _addGrade,
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
            final updatedModule = Modules(
              name: _nameController.text,
              code: _codeController.text,
              lecturer: _lecturerController.text,
              room: _roomController.text,
              contact: _contactController.text,
              lp: int.tryParse(_lpController.text) ?? 0,
              color: _color,
              exams: _exams,
              grades: _grades,
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

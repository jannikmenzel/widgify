import 'package:flutter/material.dart';
import 'package:widgify/pages/main/modules/modules_utils.dart';

class ExamCardWidget extends StatelessWidget {
  const ExamCardWidget({super.key});

  Future<List<Map<String, String>>> _getAllUpcomingExams() async {
    List<Modules> modules = await loadModules();
    List<Map<String, String>> allExamsWithModules = [];
    for (var module in modules) {
      for (var exam in module.exams) {
        allExamsWithModules.add({
          'exam': exam,
          'module': module.name,
        });
      }
    }
    allExamsWithModules.sort((a, b) => a['exam']!.compareTo(b['exam']!));
    return allExamsWithModules;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: _getAllUpcomingExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Fehler: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Keine anstehenden Klausuren gefunden'));
        }
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 5,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'Anstehende Klausuren',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!
                    .map((examData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${examData['module']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Datum: ${examData['exam']}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                })
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GradeCardWidget extends StatelessWidget {
  const GradeCardWidget({super.key});

  Future<List<Map<String, String>>> _getAllModuleGrades() async {
    List<Modules> modules = await loadModules();
    List<Map<String, String>> allGradesWithModules = [];
    for (var module in modules) {
      for (var grade in module.grades) {
        allGradesWithModules.add({
          'grade': grade.toString(),
          'module': module.name,
        });
      }
    }
    return allGradesWithModules;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: _getAllModuleGrades(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Fehler: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Keine Noten gefunden'));
        }
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 5,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'Noten der Module',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!
                    .map((gradeData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${gradeData['module']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Note: ${gradeData['grade']}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                })
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
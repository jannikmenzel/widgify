import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studyController = TextEditingController();
  String _name = '';
  String _studyField = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _studyField = prefs.getString('studyField') ?? '';
      _nameController.text = _name;
      _studyController.text = _studyField;
    });
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('studyField', _studyController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account',
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name', style: AppTypography.body),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Name eingeben'),
              onChanged: (text) {
                setState(() {
                  _name = text;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Studiengang', style: AppTypography.body),
            TextField(
              controller: _studyController,
              decoration: InputDecoration(hintText: 'Studiengang eingeben'),
              onChanged: (text) {
                setState(() {
                  _studyField = text;
                });
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 25.0),
        child: ElevatedButton(
          onPressed: () {
            _saveData();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Aktualisiert')));
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: Text(
            'Speichern',
          ),
        ),
      ),
    );
  }
}
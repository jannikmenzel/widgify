import 'package:flutter/material.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/components/bottom_navigation_bar.dart';
import 'package:widgify/pages/main/home_page.dart';
import 'package:widgify/pages/main/modules_page.dart';
import 'package:widgify/pages/main/music_player_page.dart';
import 'package:widgify/pages/main/tasks_page.dart';
import 'package:widgify/pages/main/week_plan_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    WeekPlanPage(),
    TasksPage(),
    ModulesPage(),
    MusicPlayerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Widgify',
        leadingIcon: Icons.notifications,
        trailingIcon: Icons.settings,
        isCentered: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
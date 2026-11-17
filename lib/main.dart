import 'package:flutter/material.dart';

import 'common/app_theme.dart';
import 'common/bottom_nav.dart';

import 'home/home_page.dart';
import 'home/task_model.dart';
import 'calendar/calendar_page.dart';
import 'cookie/cookie_page.dart';
import 'setting_page.dart';

void main() {
  runApp(const KwajakApp());
}

class KwajakApp extends StatelessWidget {
  const KwajakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  // 모든 페이지에서 공유하는 과제 데이터
  final List<Assignment> _tasks = [];

  // 과제 데이터 변경 시 화면 갱신
  void _refreshTasks() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        tasks: _tasks,
        onTasksChanged: _refreshTasks,
      ),

      CalendarPage(
        tasks: _tasks,
      ),

      const CookiePage(),
      const SettingPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

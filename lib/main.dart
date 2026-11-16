
import 'package:flutter/material.dart';

import 'common/app_theme.dart';
import 'common/bottom_nav.dart';

import 'home/home_page.dart';
import 'calendar/calendar_page.dart';
import 'cookie/cookie_page.dart';
import 'setting_page.dart';
import 'cookie/cookie_page.dart';

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

  final List<Widget> pages = const [
    HomePage(),
    CalendarPage(),
    CookiePage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
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

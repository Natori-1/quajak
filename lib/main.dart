import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/app_theme.dart';
import 'common/bottom_nav.dart';

import 'home/home_page.dart';
import 'home/task_model.dart';
import 'calendar/calendar_page.dart';
import 'cookie/cookie_page.dart';
import 'setting_page.dart';
import 'login/login_page.dart';

import 'notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화
  await NotificationService.initialize();

  runApp(const KwajakApp());
}

class KwajakApp extends StatelessWidget {
  const KwajakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginPage(),
      routes: {
        '/main': (context) => const MainPage(),
      },
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

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // 앱 실행 시 저장된 과제 불러오기
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = prefs.getString('saved_tasks');

    if (savedData == null) return;

    try {
      final List<dynamic> decodedData = jsonDecode(savedData);

      final loadedTasks = decodedData.map((item) {
        return Assignment.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        _tasks
          ..clear()
          ..addAll(loadedTasks);
      });

      // 저장된 과제들의 알림 복구
      await NotificationService.rescheduleAll(_tasks);

    } catch (e) {
      debugPrint('과제 불러오기 실패: $e');
    }
  }

  // 과제 목록 휴대폰에 저장
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedData = jsonEncode(
      _tasks.map((task) => task.toJson()).toList(),
    );

    await prefs.setString('saved_tasks', encodedData);
  }

  // 과제 데이터 변경 시 화면 갱신 및 저장
  void _refreshTasks() {
    setState(() {});
    _saveTasks();
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

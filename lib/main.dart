
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

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

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  // 현재 로그인한 사용자의 과제 불러오기
  Future<void> _loadTasks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc('current')
          .get();

      if (!doc.exists) return;

      final data = doc.data();
      final savedData = data?['items'];

      if (savedData is! List) return;

      // 저장된 데이터를 Assignment 객체로 변환
      final loadedTasks = savedData.map((item) {
        return Assignment.fromJson(
          Map<String, dynamic>.from(item as Map),
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

  // 현재 사용자의 과제를 Firestore에 저장
  Future<void> _saveTasks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final taskData = _tasks.map((task) {
        return task.toJson();
      }).toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc('current')
          .set({
        'items': taskData,
      });

      debugPrint('과제 저장 성공');

    } catch (e) {
      debugPrint('과제 저장 실패: $e');
    }
  }

  // 과제 변경 시 화면 갱신 및 서버 저장
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

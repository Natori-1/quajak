
import 'package:flutter/material.dart';
import 'app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.brown,
      unselectedItemColor: AppColors.gray,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: '캘린더',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cookie_outlined),
          label: '쿠키함',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '설정',
        ),
      ],
    );
  }
}

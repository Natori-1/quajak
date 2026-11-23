import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'common/app_theme.dart';
import 'common/app_card.dart';
import 'login/login_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  // 안내 팝업
  void _showInfo(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cream,
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                '확인',
                style: TextStyle(color: AppColors.brown),
              ),
            ),
          ],
        );
      },
    );
  }

  // 로그아웃
  
  // 로그아웃
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃하시겠어요?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                // 확인 창 닫기
                Navigator.pop(dialogContext);

                try {
                  // Firebase 실제 로그아웃
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

                  // 로그인 화면으로 이동
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );

                } catch (e) {
                  debugPrint('로그아웃 오류: $e');

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그아웃에 실패했습니다.'),
                    ),
                  );
                }
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          '설정',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        // 프로필
        AppCard(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.cream,
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: AppColors.brown,
                ),
              ),

              const SizedBox(width: 15),

              
Expanded(
  child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: user == null
        ? null
        : FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),

    builder: (context, snapshot) {
      final data = snapshot.data?.data();

      final name = data?['name'] as String? ?? '콰작 사용자';
      final email = user?.email ?? '';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.connectionState == ConnectionState.waiting
                ? '불러오는 중...'
                : name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.gray,
            ),
          ),
        ],
      );
    },
  ),
),


              IconButton(
                onPressed: () {
                  _showInfo(
                    context,
                    '내 프로필',
                    '콰작!과 함께 과제를 관리해 보세요.',
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.brown,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 앱 설정
        const Text(
          '앱 설정',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),

        const SizedBox(height: 10),

        AppCard(
          child: Column(
            children: [
              SettingItem(
                icon: Icons.notifications_none,
                title: '알림 설정',
                onTap: () {
                  _showInfo(
                    context,
                    '알림 설정',
                    '과제 마감일 알림 기능은 준비 중입니다.',
                  );
                },
              ),

              SettingItem(
                icon: Icons.palette_outlined,
                title: '테마 설정',
                onTap: () {
                  _showInfo(
                    context,
                    '테마 설정',
                    '현재 기본 테마를 사용하고 있습니다.',
                  );
                },
              ),

              SettingItem(
                icon: Icons.card_giftcard,
                title: '포춘쿠키 안내',
                onTap: () {
                  _showInfo(
                    context,
                    '포춘쿠키',
                    '모든 과제를 완료하면 포춘쿠키를 받을 수 있어요!',
                  );
                },
              ),

              SettingItem(
                icon: Icons.campaign_outlined,
                title: '공지사항',
                onTap: () {
                  _showInfo(
                    context,
                    '공지사항',
                    '콰작!을 이용해 주셔서 감사합니다.\n더 나은 서비스를 위해 노력하겠습니다!',
                  );
                },
              ),

              SettingItem(
                icon: Icons.info_outline,
                title: '앱 정보',
                onTap: () {
                  _showInfo(
                    context,
                    '콰작!',
                    '과제를 작살낸다!\n버전 1.0.0',
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // 계정 관리
        const Text(
          '계정 관리',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),

        const SizedBox(height: 10),

        AppCard(
          child: SettingItem(
            icon: Icons.logout,
            title: '로그아웃',
            color: Colors.redAccent,
            onTap: () => _logout(context),
          ),
        ),

        const SizedBox(height: 25),

        const Center(
          child: Text(
            '콰작! · 과제를 작살낸다',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray,
            ),
          ),
        ),
      ],
    );
  }
}

// 설정 항목 위젯
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = AppColors.brown,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 55,
        child: Row(
          children: [
            Icon(icon, color: color),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppColors.gray,
            ),
          ],
        ),
      ),
    );
  }
}

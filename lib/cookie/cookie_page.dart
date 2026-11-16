
import 'dart:math';
import 'package:flutter/material.dart';

// 콰작! 색상
const Color cookieBg = Color(0xFFFFF8F5);
const Color cookieBrown = Color(0xFF9B6848);
const Color cookieDark = Color(0xFF49352D);
const Color cookieMuted = Color(0xFFAA9690);
const Color cookieCard = Color(0xFFFFFEFD);

// ======================================================
// 쿠키함 페이지
// ======================================================

class CookiePage extends StatefulWidget {
  const CookiePage({super.key});

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  String _selectedCategory = '전체';

  final List<String> _categories = [
    '전체',
    '행운',
    '위로',
    '도전',
  ];

  //나중에 삭제할 부분
  void _showFortuneCookie() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const FortuneCookieDialog();
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cookieBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              '나의 쿠키함',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: cookieDark,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              '콰작!이 모아준 작은 응원들을 확인해 봐.',
              style: TextStyle(
                fontSize: 13,
                color: cookieMuted,
              ),
            ),

            const SizedBox(height: 22),

            // 쿠키함 안내 카드
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cookieCard,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: cookieBrown.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Text(
                    '🥠',
                    style: TextStyle(fontSize: 48),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '오늘도 수고했어!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cookieDark,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '과제를 완료하고 행운의 메시지를 모아 봐.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: cookieMuted,
                    ),
                  ),
                ],
              ),
            ),
            //나중에 삭제할부분
                        const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showFortuneCookie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cookieBrown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  '🥠 포춘쿠키 깨뜨리기!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),



            const SizedBox(height: 25),

            // 카테고리
            const Text(
              '쿠키 카테고리',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cookieDark,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: _categories.map((category) {
                final selected =
                    _selectedCategory == category;

                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  selectedColor: cookieBrown,
                  backgroundColor: cookieCard,
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : cookieMuted,
                    fontWeight: FontWeight.bold,
                  ),
                  side: BorderSide.none,
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            const Text(
              '모아둔 쿠키',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cookieDark,
              ),
            ),

            const SizedBox(height: 12),

            // 아직 받은 쿠키가 없을 때
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 35,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: cookieCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.cookie_outlined,
                    size: 42,
                    color: cookieMuted,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '아직 모아둔 쿠키가 없어.',
                    style: TextStyle(
                      color: cookieDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '과제를 모두 완료하고 첫 쿠키를 받아 봐!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: cookieMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// 포춘쿠키 애니메이션 팝업
// ======================================================

class FortuneCookieDialog extends StatefulWidget {
  const FortuneCookieDialog({super.key});

  @override
  State<FortuneCookieDialog> createState() =>
      _FortuneCookieDialogState();
}

class _FortuneCookieDialogState
    extends State<FortuneCookieDialog> {

  int _tapCount = 0;

  late final String _message;

  final List<String> _messages = [
    '오늘도 해냈어! 정말 대단해!',
    '작은 노력도 모이면 큰 결과가 돼!',
    '오늘의 너는 어제보다 더 성장했어!',
    '모든 과제를 끝낸 너에게 박수를!',
    '고생 많았어. 오늘은 마음 편히 쉬어!',
    '포기하지 않은 네가 오늘의 주인공이야!',
    '앞으로도 너만의 속도로 나아가면 돼!',
    '오늘 하루도 충분히 잘 해냈어!',
  ];

  bool get _isComplete => _tapCount >= 4;

  String get _currentImage {
    if (_tapCount == 0 || _tapCount == 2) {
      return 'assets/images/qwazak1_transparent.png';
    }

    if (_tapCount == 1 || _tapCount == 3) {
      return 'assets/images/qwazak2_transparent.png';
    }

    return 'assets/images/qwazak3_transparent.png';
  }

  @override
  void initState() {
    super.initState();

    _message =
        _messages[Random().nextInt(_messages.length)];
  }

  void _breakCookie() {
    if (_isComplete) return;

    setState(() {
      _tapCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: cookieBg,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '콰작! 미션 클리어!',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: cookieDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _isComplete
                  ? '행운의 메시지가 도착했어!'
                  : '포춘쿠키를 터치해서 깨뜨려 봐!',
              style: const TextStyle(
                fontSize: 13,
                color: cookieMuted,
              ),
            ),

            const SizedBox(height: 15),

            // 이미지 터치 및 전환 애니메이션
            GestureDetector(
              onTap: _breakCookie,
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 350,
                ),
                switchInCurve: Curves.elasticOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: RotationTransition(
                      turns: Tween<double>(
                        begin: -0.04,
                        end: 0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  _currentImage,
                  key: ValueKey(_currentImage),
                  width: 270,
                  height: 270,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 터치 안내
            if (!_isComplete)
              Text(
                '톡! 톡! 터치해서 쿠키를 깨뜨려!',
                style: const TextStyle(
                  color: cookieBrown,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

            // 쿠키 파괴 완료 후 응원 문구
            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 500,
              ),
              child: _isComplete
                  ? Column(
                      key: const ValueKey('message'),
                      children: [
                        const Text(
                          '✦ TODAY\'S FORTUNE ✦',
                          style: TextStyle(
                            color: cookieBrown,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            fontWeight: FontWeight.w800,
                            color: cookieDark,
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cookieBrown,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              '고마워! 내일도 콰작!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(
                      key: ValueKey('empty'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

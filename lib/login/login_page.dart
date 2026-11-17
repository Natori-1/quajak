
import 'package:flutter/material.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController =
      TextEditingController();

  final TextEditingController _pwController =
      TextEditingController();

  bool _hidePassword = true;

  void _login() {
    if (_idController.text.trim().isEmpty ||
        _pwController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('아이디와 비밀번호를 입력해 주세요.'),
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF9B6848);
    const dark = Color(0xFF49352D);
    const muted = Color(0xFFAA9690);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🥠',
                  style: TextStyle(fontSize: 75),
                ),

                const SizedBox(height: 10),

                const Text(
                  '콰작!',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: brown,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  '과제를 작살낸다!',
                  style: TextStyle(
                    fontSize: 15,
                    color: muted,
                  ),
                ),

                const SizedBox(height: 45),

                const Text(
                  '만나서 반가워!',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '로그인하고 과제 정복을 시작해 봐.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: '아이디를 입력해 줘',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: brown,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _pwController,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해 줘',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: brown,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: muted,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupPage(),
          ),
        );
      },
      child: const Text(
        '회원가입',
        style: TextStyle(
          color: Color(0xFF9B6848),
        ),
      ),
    ),

    const Text('|'),

    TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('비밀번호 찾기 기능은 준비 중입니다.'),
          ),
        );
      },
      child: const Text(
        '비밀번호 찾기',
        style: TextStyle(
          color: Color(0xFF9B6848),
        ),
      ),
    ),
  ],
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

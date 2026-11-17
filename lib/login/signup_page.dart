
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwCheckController = TextEditingController();

  void _signup() {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    final pwCheck = _pwCheckController.text.trim();

    String? error;

    if (id.isEmpty || pw.isEmpty || pwCheck.isEmpty) {
      error = '모든 항목을 입력해 주세요.';
    } else if (pw.length < 6) {
      error = '비밀번호는 6자리 이상 입력해 주세요.';
    } else if (pw != pwCheck) {
      error = '비밀번호가 일치하지 않습니다.';
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('회원가입이 완료되었습니다!')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pwCheckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F5),
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Text(
              '콰작!과 함께 과제를 시작해 봐!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF49352D),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _pwCheckController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B6848),
                  foregroundColor: Colors.white,
                ),
                child: const Text('가입하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

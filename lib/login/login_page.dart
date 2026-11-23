
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _idController.text.trim();
    final password = _pwController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일과 비밀번호를 입력해 주세요.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/main');

    } on FirebaseAuthException catch (e) {
      String message = '로그인에 실패했습니다.';

      if (e.code == 'user-not-found') {
        message = '가입되지 않은 이메일입니다.';
      } else if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = '이메일 또는 비밀번호가 올바르지 않습니다.';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식이 올바르지 않습니다.';
      } else if (e.code == 'too-many-requests') {
        message = '로그인 시도가 너무 많습니다. 잠시 후 다시 시도해 주세요.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

    } catch (e) {
      debugPrint('로그인 오류: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인 중 오류가 발생했습니다.'),
        ),
      );

    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: '이메일을 입력해 줘',
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
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
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
                            builder: (context) =>
                                const SignupPage(),
                          ),
                        );
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(color: brown),
                      ),
                    ),

                    const Text('|'),

                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '비밀번호 찾기 기능은 준비 중입니다.',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        '비밀번호 찾기',
                        style: TextStyle(color: brown),
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

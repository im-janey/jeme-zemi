import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // 컨트롤러 선언
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Firebase 관련 객체 (현재 주석 처리됨)
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 회원가입 메서드
  Future<void> _signUp() async {
    final nickname = _nicknameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 입력값 유효성 검사
    if (nickname.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임, 이메일 및 비밀번호를 입력하세요.')),
      );
      return;
    }

    try {
      // Firebase 회원가입 로직 (주석 처리됨)
      // UserCredential userCredential =
      //     await _auth.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // 랜덤 이미지 선택 (테스트용)
      List<String> imageLinks = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];
      String randomImage = imageLinks[Random().nextInt(imageLinks.length)];

      // Firestore에 사용자 정보 저장 (주석 처리됨)
      // await _firestore.collection('users').doc(userCredential.user?.uid).set({
      //   'nickname': nickname,
      //   'email': email,
      //   'image': randomImage,
      //   'createdAt': FieldValue.serverTimestamp(),
      // });

      print("회원가입 성공: $email");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공!')),
      );

      // 회원가입 성공 후 이전 화면으로 이동
      Navigator.pop(context);
    } catch (e) {
      print("회원가입 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 테마 상태를 감지 (다크 모드 여부 확인)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 129),
              // 닉네임 입력 필드
              _buildTextField(
                '닉네임을 입력해주세요',
                Icons.person,
                _nicknameController,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),
              // 이메일 입력 필드
              _buildTextField(
                '이메일을 입력해주세요',
                Icons.email,
                _emailController,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),
              // 비밀번호 입력 필드
              _buildTextField(
                '비밀번호를 입력해주세요',
                Icons.lock,
                _passwordController,
                obscureText: true,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),
              // 비밀번호 확인 입력 필드
              _buildTextField(
                '비밀번호를 한 번 더 입력해주세요',
                Icons.lock,
                _confirmPasswordController,
                obscureText: true,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 40),
              // 회원가입 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 로그인 화면으로 이동
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                    children: const [
                      TextSpan(text: '이미 계정이 있으신가요? '),
                      TextSpan(
                        text: '로그인',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 입력 필드 생성 위젯
  Widget _buildTextField(
    String labelText,
    IconData icon,
    TextEditingController controller, {
    bool obscureText = false,
    required bool isDarkMode,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
        ),
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      cursorColor: Theme.of(context).primaryColor,
    );
  }
}

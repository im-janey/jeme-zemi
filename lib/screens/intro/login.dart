import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:misson_0/screens/intro/signup.dart';

import '../home/app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User user = userCredential.user!;

      await _checkAndCreateUserDocument(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppPage()),
      );
    }
  } catch (e) {
    print("Google Sign-In Error: $e");
  }
}

Future<void> signInAsGuest(BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    User user = userCredential.user!;

    await _checkAndCreateUserDocument(user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AppPage()),
    );
  } catch (e) {
    print("Guest Sign-In Error: $e");
  }
}

Future<void> _checkAndCreateUserDocument(User user) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userDoc = await firestore.collection('users').doc(user.uid).get();

  if (!userDoc.exists) {
    String name = user.displayName ?? 'Anonymous';
    String email = user.email ?? 'No email provided';
    String statusMessage = 'I promise to take the test honestly before GOD.';

    if (user.isAnonymous) {
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'status_message': statusMessage,
        'cart': [],
      });
    } else {
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'status_message': statusMessage,
        'cart': [],
      });
    }
  } else {
    if (!userDoc.data()!.containsKey('cart')) {
      await firestore.collection('users').doc(user.uid).update({
        'cart': [],
      });
    }
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _logIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppPage()),
      );
    } catch (e) {
      print("로그인 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패: 다시 입력해주세요')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            SizedBox(
              width: 100,
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(height: 30),
            Text(
              '만나서 반가워요',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // 이메일 입력 필드
            _buildTextField(
              '이메일을 입력해주세요',
              Icons.email,
              isDarkMode: isDarkMode,
              controller: _emailController,
            ),
            const SizedBox(height: 16.0),
            // 비밀번호 입력 필드
            _buildTextField(
              '비밀번호를 입력해주세요',
              Icons.lock,
              isDarkMode: isDarkMode,
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // 회원가입 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[300], // 다크 모드 시 더 어두운 회색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => signInWithGoogle(context),
                icon: Image.asset(
                  'assets/google.png', // Google 로고 이미지 (assets에 추가 필요)
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  "구글로 로그인",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white, // 텍스트 및 아이콘 색상 검정
                  side: BorderSide(
                      color: Colors.grey.shade300, width: 1.5), // 테두리 추가
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => signInAsGuest(context),
                icon: const Icon(
                  Icons.person,
                  color: Colors.white, // 아이콘 색상 흰색
                ),
                label: const Text(
                  "게스트로 로그인",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent, // 텍스트 및 아이콘 색상 흰색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, IconData icon,
      {bool obscureText = false,
      required bool isDarkMode,
      TextEditingController? controller}) {
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
      ),
    );
  }
}

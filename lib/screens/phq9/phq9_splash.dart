import 'package:flutter/material.dart';

import '../home/setting.dart';
import 'phq9_history.dart';

class PHQ9SplashScreen extends StatelessWidget {
  final VoidCallback onSplashComplete;

  const PHQ9SplashScreen({super.key, required this.onSplashComplete});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), onSplashComplete);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PHQ9History()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 좌측 정렬
          children: [
            const Text(
              "PHQ-9는",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            const Text(
              "간단하면서도 효과적인 정신건강 검사 도구입니다. \n이를 통해 함께 마음을 나누고 하나님 사랑을 전하는 시간을 가져보는 건 어떨까요?",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // 이미지 가운데 정렬
            Center(
              child: SizedBox(
                width: 350,
                child: Image.asset('assets/phq9.png'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

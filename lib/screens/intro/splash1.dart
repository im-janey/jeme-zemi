import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'splash2.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  double _planeX = -400; // 초기 X 위치
  double _planeY = -400; // 초기 Y 위치

  @override
  void initState() {
    super.initState();

    // 비행기 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 480), () {
        setState(() {
          _planeX = MediaQuery.of(context).size.width; // 화면 끝까지
          _planeY = MediaQuery.of(context).size.height; // 화면 아래 끝까지
        });
      });
    });

    // 화면 전환
    Timer(const Duration(milliseconds: 3500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Splash2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.blue[100],
      body: Stack(
        children: [
          // 배경 애니메이션
          RiveAnimation.asset(
            isDarkMode
                ? 'assets/sky_moon_night.riv' // 다크 모드
                : 'assets/sky_sun_cloud.riv', // 라이트 모드
            fit: BoxFit.cover,
          ),
          // 비행기 애니메이션
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            left: _planeX,
            top: _planeY,
            child: SizedBox(
              width: 300,
              child: Image.asset('assets/plane.png'),
            ),
          ),
        ],
      ),
    );
  }
}

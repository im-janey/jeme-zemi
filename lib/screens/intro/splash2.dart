import 'package:flutter/material.dart';
import 'login.dart';

import '../../packages/button.dart';

class Splash2 extends StatefulWidget {
  const Splash2({super.key});

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 페이지 뷰
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              SplashPage(
                imagePath: 'assets/logo.png',
                mainText: 'JeMe-ZeMi',
                subText: 'Jesus & Me, #Zero Mission',
                isDarkMode: isDarkMode,
              ),
              SplashPage(
                imagePath: 'assets/logo.png',
                mainText: '시작해볼까요?',
                subText: '당신의 미션트립에 함께할게요',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
          // 페이지 인디케이터
          Positioned(
            bottom: 50,
            child: PageIndicator(
              pageCount: 2,
              currentPage: _currentPage,
              isDarkMode: isDarkMode,
            ),
          ),
          // 시작 버튼
          if (_currentPage == 1)
            Positioned(
              bottom: 200,
              child: StartButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                text: '좋아요 🦋', // 원하는 텍스트 전달
              ),
            ),
        ],
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final String imagePath;
  final String mainText;
  final String subText;
  final bool isDarkMode;

  const SplashPage({
    super.key,
    required this.imagePath,
    required this.mainText,
    required this.subText,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      children: [
        const SizedBox(height: 225),
        Image.asset(imagePath, height: 200),
        const SizedBox(height: 40),
        Text(
          mainText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          subText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final bool isDarkMode;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Colors.blueAccent;
    final inactiveColor = isDarkMode ? Colors.white54 : Colors.grey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? activeColor : inactiveColor,
          ),
        ),
      ),
    );
  }
}

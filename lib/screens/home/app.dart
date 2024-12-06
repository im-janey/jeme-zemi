import 'package:flutter/material.dart';

import '../diary/calender.dart';
import '../phq9/phq9.dart';
import '../phq9/phq9_splash.dart';
import 'home.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  var selectedIndex = 1;
  bool showSplash = true; // 스플래시 페이지 상태

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // 현재 페이지 설정
    Widget page;
    if (selectedIndex == 0) {
      if (showSplash) {
        page = PHQ9SplashScreen(
          onSplashComplete: () {
            setState(() {
              showSplash = false;
            });
          },
        );
      } else {
        page = const PHQ9Page();
      }
    } else if (selectedIndex == 1) {
      page = const HomePage();
    } else if (selectedIndex == 2) {
      page = CalendarPage();
    } else {
      throw UnimplementedError('No widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.diversity_1),
                      label: 'PHQ9',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.face),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.draw),
                      label: 'Diary',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                      if (value != 0)
                        showSplash = true; // PHQ9가 아닌 페이지로 전환 시 스플래시 초기화
                    });
                  },
                ),
              ],
            );
          } else {
            return Row(
              children: [
                NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.diversity_1),
                      label: Text('PHQ9'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.face),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.draw),
                      label: Text('Diary'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                      if (value != 0)
                        showSplash = true; // PHQ9가 아닌 페이지로 전환 시 스플래시 초기화
                    });
                  },
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

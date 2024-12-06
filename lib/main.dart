import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/intro/splash1.dart';

// 공통 색상 정의 (웜한 초록색과 블루색 적용)
const primaryColor = Color(0xFF6ABF69); // 따뜻한 초록색
const secondaryColor = Color(0xFF5C8AFF); // 따뜻한 블루색

// 공통 텍스트 스타일
const textTheme = TextTheme(
  bodyLarge: TextStyle(
    fontFamily: 'Nanum_Gothic,Parkinsans',
    color: Colors.black,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Nanum_Gothic,Parkinsans',
    color: Colors.black,
  ),
);

const darkTextTheme = TextTheme(
  bodyLarge: TextStyle(
    fontFamily: 'Nanum_Gothic,Parkinsans',
    color: Colors.white,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Nanum_Gothic,Parkinsans',
    color: Colors.white,
  ),
);

// 공통 앱바 테마
AppBarTheme appBarTheme(Color backgroundColor) => AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
    );

// 라이트 테마
final ThemeData lightTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white, // 라이트 모드 배경을 흰색으로 설정
  appBarTheme: appBarTheme(Colors.white),
  textTheme: textTheme,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Colors.white,
    background: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
  ),
  indicatorColor: primaryColor,
  useMaterial3: true,
);

// 다크 테마
final ThemeData darkTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.black, // 다크 모드 배경을 검은색으로 설정
  appBarTheme: appBarTheme(Colors.black),
  textTheme: darkTextTheme,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Colors.black,
    background: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
  ),
  indicatorColor: primaryColor,
  useMaterial3: true,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mission #0',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const Splash1(),
    );
  }
}

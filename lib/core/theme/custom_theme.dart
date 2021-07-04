import 'package:flutter/material.dart';

class CustomTheme {
  ///generic colors
  static const Color successGreen = Color(0xFF1CAE4B);
  static const Color blueColor = Color(0xFF1F8CBD);
  static const Color errorRed = Color(0xFF9B1B33);
  static const Color orangeColor = Color(0xFFC8511B);

  static ThemeData themeData = ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'AvenirNext',
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      buttonColor: Colors.grey,
      textTheme: textTheme);

  static TextTheme textTheme = TextTheme(
    headline4: const TextStyle(fontSize: 36.0, color: Colors.black),
    headline5: const TextStyle(fontSize: 27.0, color: Colors.black),
    subtitle1: const TextStyle(fontSize: 18.0, color: Colors.black),
    subtitle2: const TextStyle(fontSize: 16.0, color: Colors.black),
    bodyText1: const TextStyle(fontSize: 14.0, color: Colors.black),
    bodyText2: const TextStyle(fontSize: 12.0, color: Colors.black),
  );
}

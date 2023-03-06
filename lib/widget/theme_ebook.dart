import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeEbook extends ChangeNotifier {
  bool isLight;

  ThemeEbook({required this.isLight});

  getNavigationBarTheme() {
    if (isLight) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFFFFFFFF),
          systemNavigationBarIconBrightness: Brightness.dark));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF26242E),
          systemNavigationBarIconBrightness: Brightness.light));
    }
  }
}

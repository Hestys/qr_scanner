import 'package:flutter/material.dart';

class DarkThemeColor {
  static DarkThemeColor? _instance;
  static DarkThemeColor get instance {
    _instance ??= _instance = DarkThemeColor._init();
    return _instance!;
  }

  DarkThemeColor._init();
  final Color blue = Color(0xff325CFD);
  final Color black = Color(0xff1D1F22);
}

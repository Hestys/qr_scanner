import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme.dart';
import 'dark/dark_theme_interface.dart';

class DarkTheme extends AppTheme with IDarkTheme {
  static DarkTheme? _instance;
  static DarkTheme get instance {
    _instance ??= _instance = DarkTheme._init();
    return _instance!;
  }

  @override
  ThemeData get theme => ThemeData(
      scaffoldBackgroundColor: colorSchema.black,
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: _appBarTheme,
      colorScheme: _colorSceheme,
      inputDecorationTheme: _inputDecorationTheme);

  ColorScheme get _colorSceheme => ColorScheme(
      primary: colorSchema.blue,
      primaryVariant: Colors.white,
      secondary: colorSchema.black,
      secondaryVariant: Colors.white,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: colorSchema.black,
      brightness: Brightness.dark);

  AppBarTheme get _appBarTheme => ThemeData.dark().appBarTheme.copyWith(
      centerTitle: true,
      color: Colors.transparent,
      elevation: 0,
      titleTextStyle: textTheme.appBarTextTheme);

  InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.white)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      );

  DarkTheme._init();
}

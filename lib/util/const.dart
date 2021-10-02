import 'package:flutter/material.dart';

class Constants {
  static String appName = "PesenSayur";

  //Colors for theme
  static Color lightPrimary = Color(0xfff0f0f0);
  static Color darkPrimary = Color(0xFF1f1f1f);
  static Color lightAccent = Color(0xFF01bcd6);
  static Color darkAccent = Color(0xFF10CBD9);
  static Color lightBG = Color(0xfff0f0f0);
  static Color darkBG = Color(0xFF1f1f1f);

  static Color lightNavbarBG = Color(0xfff0f0f0);
  static Color darkNavbarBG = Color(0xFF373737);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: darkAccent,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    primaryColorDark: darkNavbarBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    primaryColorDark: lightNavbarBG,
    selectedRowColor: darkNavbarBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

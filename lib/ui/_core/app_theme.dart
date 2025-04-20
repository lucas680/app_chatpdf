import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData appTheme = ThemeData.light().copyWith(
    //sobrescrever tema
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateTextStyle.resolveWith((states) {
          return TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          );
        }),
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          } else if (states.contains(WidgetState.pressed)) {
            return const Color.fromARGB(255, 28, 124, 202);
          }
          return Colors.blueAccent;
        }),
      ),
    ),
  );
}

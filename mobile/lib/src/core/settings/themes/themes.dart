import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

class Themes {
  static final lightTheme = ThemeData.light()
      .copyWith(appBarTheme: AppBarTheme(color: Colors.transparent));
  static final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      titleTextStyle: TextStyle(color: kButtonColor, fontSize: 55),
      elevation: 0,
    ),
    scaffoldBackgroundColor: const Color(0xFF7CE26B),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xFF7CE26B),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: kButtonColor),
    // textTheme: const TextTheme(
    //   headline1: TextStyle(
    //     color: Colors.black,
    //     fontSize: 45,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   bodyText1: TextStyle(
    //     color: Colors.black,
    //     fontSize: 13,
    //     fontWeight: FontWeight.w500,
    //   ),
    // ),
    textTheme: GoogleFonts.interTextTheme(),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Colors.green,
      hoverColor: Colors.green,
      focusColor: Colors.green,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kButtonColor,
          width: 4,
        ),
      ),
      hintStyle: TextStyle(
        fontSize: 19.77,
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kButtonColor,
        foregroundColor: Colors.black,
        fixedSize: Size(Get.width / 2, Get.height / 20),
      ),
    ),
  );
}

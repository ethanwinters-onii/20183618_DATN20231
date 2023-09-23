import 'package:flutter/material.dart';

// custom color from Figma

const Color primaryColor = Color(0xffcc3562);
const Color secondaryColor = Color(0xffcc587a);
const Color customBlueColor = Color(0xff16c1f3);

const Color customColor50 = Color(0xfffcd5ce);
const Color customColor100 = Color(0xfffaac9d);
const Color customColor300 = Color(0xfff8836c);
const Color customColor400 = Color(0xfff65a3b);

const Color customColor900 = Color(0xfff4310a);
const Color customColor600 = Color(0xffc32708);

const Color customErrorRed = Color(0xFFC5032B);

const Color customSurfaceWhite = Color(0xFFFFFBFA);
const Color customBackgroundWhite = Colors.white;

class DColorSheme {
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: secondaryColor,
    primaryContainer: Colors.white,
    secondary: primaryColor,
    secondaryContainer: Colors.white,
    surface: Colors.white,
    background: Colors.white,
    error: customColor900,
    onPrimary: Colors.white,
    onSecondary: Colors.grey,
    onSurface: Colors.black,
    onBackground: Colors.grey,
    onError: primaryColor,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: secondaryColor,
    primaryContainer: customBlueColor,
    secondary: primaryColor,
    secondaryContainer: customColor400,
    surface: Colors.white,
    background: Colors.white,
    error: customColor900,
    onPrimary: Colors.white,
    onSecondary: Colors.deepOrange,
    onSurface: Colors.black,
    onBackground: customColor100,
    onError: primaryColor,
    brightness: Brightness.dark,
  );
}

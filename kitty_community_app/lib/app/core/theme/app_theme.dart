import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'color_theme.dart';
import 'text_theme.dart';

class DAppTheme {
  static ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xffcc3562),
      primaryContainer: Color(0xffffb1c6),
      secondary: Color(0xffcc587a),
      secondaryContainer: Color(0xffffd9de),
      tertiary: Color(0xff006875),
      tertiaryContainer: Color(0xff95f0ff),
      appBarColor: Color(0xffffd9de),
      error: Color(0xffb00020),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the Playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xffcc3562),
      primaryContainer: Color(0xffffb1c6),
      secondary: Color(0xffcc587a),
      secondaryContainer: Color(0xffffd9de),
      tertiary: Color(0xff006875),
      tertiaryContainer: Color(0xff95f0ff),
      appBarColor: Color(0xffffd9de),
      error: Color(0xffb00020),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the Playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );
}

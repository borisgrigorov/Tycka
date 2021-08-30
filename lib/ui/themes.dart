import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tycka/ui/components.dart';

class AppThemes {
  static const int Light = 0;
  static const int Dark = 1;
}

final themeCollection = ThemeCollection(
  themes: {
    AppThemes.Light: ThemeData(
        primaryColor: TyckaUI.primaryColor,
        accentColor: TyckaUI.secondaryColor,
        brightness: Brightness.light,
        fontFamily: GoogleFonts.openSans().fontFamily),
    AppThemes.Dark: ThemeData(
        primaryColor: TyckaUI.primaryColor,
        accentColor: TyckaUI.secondaryColor,
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.openSans().fontFamily),
  },
  fallbackTheme: ThemeData(
      primaryColor: TyckaUI.primaryColor,
      accentColor: TyckaUI.secondaryColor,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.openSans().fontFamily),
);

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    bodyMedium: GoogleFonts.roboto(fontSize: 16.0),
    bodySmall: TextStyle(fontSize: 14.0),
  ),
);

final ThemeData darkAppThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16.0),
    bodySmall: TextStyle(fontSize: 14.0),
  ),
);

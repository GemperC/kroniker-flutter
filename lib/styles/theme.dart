// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static AppTheme of(BuildContext context) {
    return LightModeTheme();
  }

  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;

  late Color grayDark;
  late Color dark900;
  late Color background;
  late Color grayIcon;
  late Color tertiary;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class DarkModeTheme extends AppTheme {
  late Color primaryColor = const Color(0xFFFD6F96);
  late Color secondaryColor = const Color(0xFFFFB67C);
  late Color tertiaryColor = const Color(0xFF1F1F1F);
  late Color alternate = const Color(0xFF6F63FF);
  late Color primaryBackground = const Color(0xFF1F1F1F);
  late Color secondaryBackground = const Color(0xFF282828);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFFA1A1A1);

  late Color grayDark = Color(0xFFA1A1A1);
  late Color dark900 = Color(0xFF1F1F1F);
  late Color background = Color(0xFF121212);
  late Color grayIcon = Color(0xFF6C6C6C);
  late Color tertiary = Color(0xFF00C3A3);

  // Define typography using ThemeTypography class just like in the LightModeTheme.
}

class LightModeTheme extends AppTheme {
  late Color primaryColor = const Color(0xFFF2569B);
  late Color secondaryColor = const Color(0xFFEE8B60);
  late Color tertiaryColor = const Color(0xFFFFFFFF);
  late Color alternate = const Color(0xFF514DFF);
  late Color primaryBackground = const Color(0x00000000);
  late Color secondaryBackground = const Color(0xFF514DFF);
  late Color primaryText = const Color(0xFFF2569B);
  late Color secondaryText = const Color(0x00000000);

  late Color grayDark = Color(0xFF616E78);
  late Color dark900 = Color(0xFF090F13);
  late Color background = Color(0xFF14181B);
  late Color grayIcon = Color(0xFF95A1AC);
  late Color tertiary = Color(0xFF39D2C0);
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final AppTheme theme;

  String get title1Family => 'Lexend Deca';
  TextStyle get title1 => GoogleFonts.getFont(
        'Lexend Deca',
        color: theme.tertiaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  String get title2Family => 'Lexend Deca';
  TextStyle get title2 => GoogleFonts.getFont(
        'Lexend Deca',
        color: theme.tertiaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 22,
      );
  String get title3Family => 'Lexend Deca';
  TextStyle get title3 => GoogleFonts.getFont(
        'Lexend Deca',
        color: theme.tertiary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );
  String get subtitle1Family => 'Lexend Deca';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Lexend Deca',
        color: theme.dark900,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      );
  String get subtitle2Family => 'Lexend Deca';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Lexend Deca',
        color: theme.tertiaryColor,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
  String get bodyText1Family => 'Lexend Deca';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Lexend Deca',
        color: theme.grayIcon,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  String get bodyText2Family => 'Lexend Deca';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Lexend Deca',
        color: theme.grayIcon,
        fontWeight: FontWeight.normal,
        fontSize: 12,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}

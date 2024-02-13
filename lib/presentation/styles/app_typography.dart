import 'package:flutter/material.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

const fontFamily = 'PublicSans';

class AppTypography {
  AppTypography(this.textColor);

  factory AppTypography.of(BuildContext context) =>
      AppTypography(context.colors.text);

  final Color textColor;

  //Headlines
  TextStyle get h1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 64,
        height: 1.25,
        color: textColor,
        fontWeight: FontWeight.w600,
      );

  TextStyle get h2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 48,
        height: 1.33,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h3 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h4 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h5 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get h6 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        height: 1.55,
        color: textColor,
        fontWeight: FontWeight.w600,
      );

  //Texts
  TextStyle get subtitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get subtitleSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.57,
        color: textColor,
        fontWeight: FontWeight.w600,
      );
  TextStyle get body => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w500,
      );
  TextStyle get bodySmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.57,
        color: textColor,
        fontWeight: FontWeight.w500,
      );
  TextStyle get caption => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w500,
      );
  TextStyle get overline => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );

  //Buttons
  TextStyle get buttonLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        height: 1.625,
        color: textColor,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );
  TextStyle get buttonMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        height: 1.71,
        color: textColor,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );
  TextStyle get buttonSmall => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        height: 1.83,
        color: textColor,
        fontWeight: FontWeight.w700,
      );
}

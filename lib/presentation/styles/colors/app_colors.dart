import 'package:flutter/material.dart';
import 'package:vibel/presentation/styles/colors/dark_app_colors.dart';
import 'package:vibel/presentation/styles/colors/light_app_colors.dart';
import 'package:vibel/presentation/styles/theme/app_theme_provider.dart';

extension AppThemeProviderX on BuildContext {
  BaseColors get colors => AppThemeProvider.of(this).colors;
}

class AppColors {
  const AppColors._();

  static LightAppColor get light => const LightAppColor();
  static DarkAppColor get dark => const DarkAppColor();
}

abstract class BaseColors {
  const BaseColors({
    required this.text,
    required this.error,
    required this.hint,
    required this.background,
    required this.correct,
    required this.warning,
    required this.primary,
  });

  final Color text;
  final Color error;
  final Color hint;
  final Color background;
  final Color correct;
  final Color warning;
  final Color primary;
}

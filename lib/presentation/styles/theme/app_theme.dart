import 'package:flutter/material.dart';
import 'package:vibel/presentation/styles/app_typography.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

class AppTheme {
  AppTheme({
    required this.colors,
  });
  AppTheme.dark() : colors = AppColors.dark;
  AppTheme.light() : colors = AppColors.light;

  factory AppTheme.fromType(ThemeMode? type, Brightness platformBrightness) {
    return switch (type) {
      ThemeMode.light => AppTheme.light(),
      ThemeMode.dark => AppTheme.dark(),
      _ => platformBrightness == Brightness.light
          ? AppTheme.light()
          : AppTheme.dark()
    };
  }

  final BaseColors colors;

  ThemeData get theme =>
      (colors == AppColors.dark ? ThemeData.dark() : ThemeData.light())
          .copyWith(
        scaffoldBackgroundColor: colors.background,
        textTheme: const TextTheme().apply(
          displayColor: colors.text,
          bodyColor: colors.text,
          fontFamily: fontFamily,
        ),
      );

  AppTheme copyWith({
    BaseColors? colors,
  }) {
    return AppTheme(
      colors: colors ?? this.colors,
    );
  }
}

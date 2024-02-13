import 'package:flutter/material.dart';

abstract class AppThemeRepository {
  Future<void> save(ThemeMode themeType);
  Future<ThemeMode> load();
}

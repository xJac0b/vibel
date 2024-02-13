import 'package:flutter/material.dart';
import 'package:injecteo/injecteo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibel/domain/theme/app_theme_repository.dart';

const _appThemeKey = 'savedThemeType';

@Singleton(as: AppThemeRepository)
class AppThemeRepositoryImpl implements AppThemeRepository {
  AppThemeRepositoryImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> save(ThemeMode themeType) async {
    await _sharedPreferences.setInt(
      _appThemeKey,
      themeType.index,
    );
  }

  @override
  Future<ThemeMode> load() async {
    final savedType = _sharedPreferences.getInt(_appThemeKey);
    return switch (savedType) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}

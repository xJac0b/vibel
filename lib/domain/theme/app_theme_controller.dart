import 'package:flutter/material.dart';
import 'package:injecteo/injecteo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibel/domain/theme/use_cases/get_app_theme_use_case.dart';
import 'package:vibel/domain/theme/use_cases/save_app_theme_use_case.dart';

class AppThemeController {
  AppThemeController._(this._saveAppThemeUseCase);

  @factoryMethod
  static Future<AppThemeController> create(
    GetAppThemeUseCase getAppColorsUseCase,
    SaveAppThemeUseCase saveAppThemeUseCase,
  ) async {
    final initialThemeType = await getAppColorsUseCase();
    final instance = AppThemeController._(saveAppThemeUseCase);
    await instance._initialize(initialThemeType);
    return instance;
  }

  late final BehaviorSubject<ThemeMode> _themeTypeSubject;
  final SaveAppThemeUseCase _saveAppThemeUseCase;

  Stream<ThemeMode> get stream => _themeTypeSubject.stream;
  ThemeMode get themeType => _themeTypeSubject.value;

  Future<void> _initialize(ThemeMode themeType) async {
    _themeTypeSubject = BehaviorSubject.seeded(themeType);
  }

  void changeTheme(ThemeMode themeType) {
    _themeTypeSubject.add(themeType);
    _saveAppThemeUseCase(themeType);
  }
}

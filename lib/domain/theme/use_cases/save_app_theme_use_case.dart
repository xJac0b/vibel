import 'package:flutter/material.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/theme/app_theme_repository.dart';

@inject
class SaveAppThemeUseCase {
  SaveAppThemeUseCase(this._repository);

  final AppThemeRepository _repository;

  Future<void> call(ThemeMode themeType) => _repository.save(themeType);
}

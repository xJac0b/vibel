import 'package:flutter/material.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/theme/app_theme_repository.dart';

@inject
class GetAppThemeUseCase {
  GetAppThemeUseCase(this._repository);

  final AppThemeRepository _repository;

  Future<ThemeMode> call() => _repository.load();
}

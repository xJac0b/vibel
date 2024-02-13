import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/theme/app_theme_controller.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@inject
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._appThemeController) : super(const HomeState.initial());

  final AppThemeController _appThemeController;
  void changeTheme(ThemeMode themeMode) {
    _appThemeController.changeTheme(themeMode);
  }
}

import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/theme/app_theme_controller.dart';
import 'package:vibel/domain/theme/use_cases/get_app_theme_use_case.dart';
import 'package:vibel/domain/theme/use_cases/save_app_theme_use_case.dart';

@externalModule
abstract class AppThemeModule {
  @preResolve
  @Singleton()
  Future<AppThemeController> appThemeController(
    GetAppThemeUseCase getAppColorsUseCase,
    SaveAppThemeUseCase saveAppThemeUseCase,
  ) =>
      AppThemeController.create(getAppColorsUseCase, saveAppThemeUseCase);
}

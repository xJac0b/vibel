import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vibel/core/di/service_locator.dart';
import 'package:vibel/domain/theme/app_theme_controller.dart';
import 'package:vibel/presentation/router/app_router.dart';
import 'package:vibel/presentation/styles/theme/app_theme.dart';
import 'package:vibel/presentation/styles/theme/app_theme_provider.dart';

class App extends HookWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    final platformBrightness = usePlatformBrightness();
    final appTheme = useStream(sl.get<AppThemeController>().stream).data;

    return MaterialApp.router(
      builder: (context, child) => AppThemeProvider(
        appTheme: AppTheme.fromType(appTheme, platformBrightness),
        child: child ?? const SizedBox.shrink(),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: sl.get<AppRouter>().router,
      themeMode: appTheme ?? ThemeMode.system,
      theme: AppTheme.light().theme,
      darkTheme: AppTheme.dark().theme,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}

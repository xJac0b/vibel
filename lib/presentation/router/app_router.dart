// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injecteo/injecteo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/domain/audio_player/repeat_mode.dart';
import 'package:vibel/presentation/pages/home/home_page.dart';
import 'package:vibel/presentation/pages/player/music_player_page.dart';
import 'package:vibel/presentation/pages/settings/pages/language/language_page.dart';
import 'package:vibel/presentation/pages/settings/pages/theme/theme_page.dart';
import 'package:vibel/presentation/pages/settings/settings_page.dart';
import 'package:vibel/presentation/router/routes.dart';

part 'app_router.g.dart';

// GoRouter configuration
@singleton
class AppRouter {
  GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.root,
    routes: $appRoutes,
  );
}

@TypedGoRoute<SplashRoute>(
  path: Routes.splash,
)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SizedBox();
}

@TypedGoRoute<HomeRoute>(
  path: Routes.root,
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@TypedGoRoute<PlayerRoute>(
  path: Routes.player,
)
class PlayerRoute extends GoRouteData {
  const PlayerRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final data = state.extra as (List<SongModel>, int, bool, bool, RepeatMode)?;
    return MusicPlayerPage(data: data);
  }
}

class ThemeRoute extends GoRouteData {
  const ThemeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ThemePage();
}

class LanguageRoute extends GoRouteData {
  const LanguageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LanguagePage();
}

@TypedGoRoute<SettingsRoute>(path: Routes.settings, routes: [
  TypedGoRoute<ThemeRoute>(
    path: Routes.theme,
  ),
  TypedGoRoute<LanguageRoute>(
    path: Routes.language,
  ),
])
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

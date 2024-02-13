import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/presentation/pages/home/home_page.dart';
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

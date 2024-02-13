import 'package:injecteo/injecteo.dart';
import 'package:vibel/core/di/di.config.dart';
import 'package:vibel/core/di/service_locator.dart';

@InjecteoConfig(preferRelativeImports: false)
Future<void> configureDependencies(String env) async => $injecteoConfig(
      sl,
      environment: env,
    );

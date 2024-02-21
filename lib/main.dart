import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:injecteo/injecteo.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logger/logger.dart';
import 'package:vibel/core/app_bloc_observer.dart';
import 'package:vibel/core/di/di.dart';
import 'package:vibel/core/di/service_locator.dart';
import 'package:vibel/domain/language/language_code.dart';
import 'package:vibel/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Injecteo
  await configureDependencies(Environment.prod);

  //Error logging
  FlutterError.onError = (details) {
    Logger().e(details.exceptionAsString(), stackTrace: details.stack);
  };
  Bloc.observer = const AppBlocObserver();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(await _easyLocalization());
}

//Easy Localization
Future<EasyLocalization> _easyLocalization() async {
  await EasyLocalization.ensureInitialized();

  return EasyLocalization(
    path: 'assets/translations',
    supportedLocales: availableLocales.values.toList(),
    fallbackLocale: availableLocales[fallbackLanguageCode],
    useOnlyLangCode: true,
    saveLocale: true,
    child: HookedBlocConfigProvider(
      injector: () => sl,
      child: const App(),
    ),
  );
}

import 'dart:ui';

enum LanguageCode { en, pl }

const fallbackLanguageCode = LanguageCode.en;

Map<LanguageCode, Locale> availableLocales = {
  LanguageCode.en: const Locale('en'),
  LanguageCode.pl: const Locale('pl'),
};

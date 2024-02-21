import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibel/domain/language/language_code.dart';
import 'package:vibel/generated/local_keys.g.dart';
import 'package:vibel/presentation/pages/settings/widgets/settings_button.dart';
import 'package:vibel/presentation/shared/app_bar_widget.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';

class LanguagePage extends HookWidget {
  const LanguagePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarWidget(title: LocaleKeys.settings_language.tr()),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacings.twentyFour),
            sliver: SliverFillRemaining(
              child: Column(
                children: availableLocales.entries
                    .map(
                      (e) => LanguageButton(
                        code: e.key,
                        active: context.locale == e.value,
                        locale: e.value,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    required this.code,
    required this.active,
    required this.locale,
    super.key,
  });

  final LanguageCode code;
  final Locale locale;
  final bool active;

  @override
  Widget build(BuildContext context) => SettingsButton(
        text: switch (code) {
          LanguageCode.en => LocaleKeys.language_english.tr(),
          LanguageCode.pl => LocaleKeys.language_polish.tr(),
        },
        onTap: () => active ? {} : {context.setLocale(locale)},
        trailing: active
            ? const Icon(
                FontAwesomeIcons.check,
                color: Colors.grey,
                size: 16,
              )
            : null,
      );
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:vibel/generated/local_keys.g.dart';
import 'package:vibel/presentation/pages/settings/pages/theme/cubit/theme_cubit.dart';
import 'package:vibel/presentation/pages/settings/widgets/settings_button.dart';
import 'package:vibel/presentation/shared/app_bar_widget.dart';
import 'package:vibel/presentation/shared/loading_indicator.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';

class ThemePage extends HookWidget {
  const ThemePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<ThemeCubit>();
    final state = useBlocBuilder(cubit);

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [cubit],
    );

    return Scaffold(
      body: state.maybeMap(
        orElse: () => const Center(child: LoadingIndicator()),
        loaded: (state) => CustomScrollView(
          slivers: [
            AppBarWidget(title: LocaleKeys.settings_theme.tr()),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacings.twentyFour),
              sliver: SliverFillRemaining(
                child: Column(
                  children: [
                    ThemeButton(
                      active: state.themeMode == ThemeMode.light,
                      mode: ThemeMode.light,
                      changeTheme: cubit.changeTheme,
                    ),
                    ThemeButton(
                      active: state.themeMode == ThemeMode.dark,
                      mode: ThemeMode.dark,
                      changeTheme: cubit.changeTheme,
                    ),
                    ThemeButton(
                      active: state.themeMode == ThemeMode.system,
                      mode: ThemeMode.system,
                      changeTheme: cubit.changeTheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    required this.mode,
    required this.changeTheme,
    required this.active,
    super.key,
  });

  final ThemeMode mode;
  final bool active;
  final void Function(ThemeMode) changeTheme;

  @override
  Widget build(BuildContext context) => SettingsButton(
        text: switch (mode) {
          ThemeMode.light => LocaleKeys.theme_light.tr(),
          ThemeMode.dark => LocaleKeys.theme_dark.tr(),
          ThemeMode.system => LocaleKeys.theme_system.tr(),
        },
        onTap: () => changeTheme(mode),
        trailing: active
            ? const Icon(
                FontAwesomeIcons.check,
                color: Colors.grey,
                size: 16,
              )
            : null,
      );
}

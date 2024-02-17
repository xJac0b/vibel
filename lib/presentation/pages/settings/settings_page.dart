import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:vibel/generated/local_keys.g.dart';
import 'package:vibel/presentation/pages/settings/cubit/settings_cubit.dart';
import 'package:vibel/presentation/pages/settings/widgets/settings_button.dart';
import 'package:vibel/presentation/router/app_router.dart';
import 'package:vibel/presentation/shared/app_bar_widget.dart';
import 'package:vibel/presentation/shared/loading_indicator.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<SettingsCubit>();
    final state = useBlocBuilder(cubit);

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [cubit],
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarWidget(title: LocaleKeys.settings_app_bar.tr()),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacings.twentyFour),
            sliver: state.maybeMap(
              orElse: () => const SliverToBoxAdapter(child: LoadingIndicator()),
              loaded: (state) => SliverList(
                delegate: SliverChildListDelegate.fixed([
                  SettingsButton(
                    leading: const Icon(
                      FontAwesomeIcons.brush,
                    ),
                    onTap: () => const ThemeRoute().push<void>(context),
                    text: LocaleKeys.settings_theme.tr(),
                    trailing: const AngleRightIcon(),
                  ),
                  SettingsButton(
                    leading: const Icon(
                      FontAwesomeIcons.globe,
                    ),
                    onTap: () => const LanguageRoute().push<void>(context),
                    text: LocaleKeys.settings_language.tr(),
                    trailing: const AngleRightIcon(),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AngleRightIcon extends StatelessWidget {
  const AngleRightIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      FontAwesomeIcons.angleRight,
      color: Colors.grey,
      size: 16,
    );
  }
}

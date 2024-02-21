import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibel/generated/local_keys.g.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';
import 'package:vibel/presentation/styles/app_typography.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

class SongSearchBar extends StatelessWidget {
  const SongSearchBar({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      backgroundColor: MaterialStateProperty.all(
        context.colors.primary,
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacings.thirtyTwo),
        ),
      ),
      controller: controller,
      hintText: LocaleKeys.home_search.tr(),
      hintStyle: MaterialStateProperty.all(
        AppTypography.of(context).body.copyWith(
              color: context.colors.hint,
            ),
      ),
      trailing: [
        controller.text.isNotEmpty
            ? IconButton(
                splashRadius: AppDimens.iconButtonSplashRadius,
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                ),
              )
            : const Icon(
                FontAwesomeIcons.magnifyingGlass,
              ),
        const SizedBox(
          width: AppSpacings.eight,
        ),
      ],
    );
  }
}

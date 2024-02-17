import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vibel/generated/local_keys.g.dart';
import 'package:vibel/presentation/styles/app_typography.dart';

class ThemePicker extends HookWidget {
  const ThemePicker({
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  final ThemeMode? initialValue;
  final void Function(ThemeMode?) onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: initialValue ?? ThemeMode.system,
      style: AppTypography.of(context).body,
      items: [
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(LocaleKeys.theme_light.tr()),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(LocaleKeys.theme_dark.tr()),
        ),
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(LocaleKeys.theme_system.tr()),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

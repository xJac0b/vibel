import 'package:flutter/material.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';
import 'package:vibel/presentation/styles/app_typography.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    required this.text,
    required this.onTap,
    this.leading,
    this.trailing,
    super.key,
  });

  final String? text;
  final Widget? leading;
  final Widget? trailing;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacings.sixteen),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                leading ?? const SizedBox(),
                const SizedBox(width: AppSpacings.sixteen),
                Text(text ?? '', style: AppTypography.of(context).body),
              ],
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

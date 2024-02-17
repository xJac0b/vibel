import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibel/presentation/styles/app_typography.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    this.title = '',
    this.actions = const [],
    super.key,
  });

  final List<Widget> actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      title: Text(title, style: AppTypography.of(context).body),
      leading: IconButton(
        icon: const Icon(FontAwesomeIcons.angleLeft),
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      actions: actions,
    );
  }
}

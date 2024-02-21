import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';

class SortAlphabeticallyButton extends StatelessWidget {
  const SortAlphabeticallyButton({
    required this.sortedAsc,
    required this.cubit,
    super.key,
  });

  final ValueNotifier<bool?> sortedAsc;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: sortedAsc.value == null || sortedAsc.value == false
          ? IconButton(
              icon: const Icon(
                FontAwesomeIcons.arrowDownAZ,
              ),
              onPressed: () {
                sortedAsc.value = true;
              },
            )
          : IconButton(
              icon: const Icon(
                FontAwesomeIcons.arrowUpAZ,
              ),
              onPressed: () {
                sortedAsc.value = false;
              },
            ),
    );
  }
}

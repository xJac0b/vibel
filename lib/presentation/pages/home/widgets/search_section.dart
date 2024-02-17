import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';
import 'package:vibel/presentation/pages/home/widgets/song_search_bar.dart';
import 'package:vibel/presentation/pages/home/widgets/sort_alphabetically.dart';
import 'package:vibel/presentation/router/app_router.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({
    required this.controller,
    required this.sortedAsc,
    required this.cubit,
    super.key,
  });

  final TextEditingController controller;
  final ValueNotifier<bool?> sortedAsc;
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.eight,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacings.twentyFour),
            Row(
              children: [
                SortAlphabeticallyButton(sortedAsc: sortedAsc, cubit: cubit),
                const SizedBox(width: AppSpacings.eight),
                Flexible(
                  child: SongSearchBar(controller: controller),
                ),
                const SizedBox(width: AppSpacings.eight),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.bars),
                  onPressed: () {
                    const SettingsRoute().push<void>(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacings.thirtyTwo),
          ],
        ),
      ),
    );
  }
}

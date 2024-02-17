import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';
import 'package:vibel/presentation/pages/home/widgets/audio_list.dart';
import 'package:vibel/presentation/pages/home/widgets/bottom_card.dart';
import 'package:vibel/presentation/pages/home/widgets/no_permission_view.dart';
import 'package:vibel/presentation/pages/home/widgets/search_section.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<HomeCubit>();
    final state = useBlocBuilder(cubit);

    final controller = useTextEditingController();
    useListenable(controller);

    final sortedAsc = useState<bool?>(null);

    useEffect(
      () {
        cubit.loadAudios();
        return null;
      },
      [],
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // HomeAppBar(cubit: cubit),
                // const SizedBox(height: AppSpacings.sixteen),
                SearchSection(
                  controller: controller,
                  sortedAsc: sortedAsc,
                  cubit: cubit,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.eight,
                  ),
                  sliver: state.map(
                    initial: (value) => const SliverFillRemaining(),
                    noPermission: (value) => NoPermissionView(cubit: cubit),
                    loaded: (loaded) => AudioList(
                      searchBarText: controller.text,
                      cubit: cubit,
                      audios: loaded.songs,
                      currentSong: loaded.currentSong,
                      paused: loaded.paused,
                    ),
                  ),
                ),
              ],
            ),
            state.mapOrNull(
                  loaded: (loaded) {
                    final song = loaded.songs[loaded.currentSong];
                    return BottomCard(
                      cubit: cubit,
                      song: song,
                      paused: loaded.paused,
                      currentSong: loaded.currentSong,
                      songs: loaded.songs,
                      pageController: loaded.bottomCardController,
                    );
                  },
                ) ??
                const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/generated/local_keys.g.dart';
import 'package:vibel/presentation/pages/player/cubit/music_player_cubit.dart';
import 'package:vibel/presentation/pages/player/widgets/player_controls.dart';
import 'package:vibel/presentation/pages/player/widgets/song_info.dart';
import 'package:vibel/presentation/pages/player/widgets/song_position_slider.dart';
import 'package:vibel/presentation/shared/app_bar_widget.dart';
import 'package:vibel/presentation/shared/loading_indicator.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';

class MusicPlayerPage extends HookWidget {
  const MusicPlayerPage({this.data, super.key});
  final (List<SongModel>, int, bool)? data;

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<MusicPlayerCubit>();
    final state = useBlocBuilder(cubit);

    useEffect(
      () {
        if (data != null) {
          cubit.init(
            songs: data!.$1,
            currentSong: data!.$2,
            paused: data!.$3,
          );
        }
        return null;
      },
      [],
    );

    return WillPopScope(
      onWillPop: () async {
        state.mapOrNull(
          loaded: (loaded) {
            context
                .pop((loaded.currentSong, loaded.isShuffle, loaded.loopMode));
            return true;
          },
        );
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            AppBarWidget(title: LocaleKeys.player_app_bar.tr()),
            ...state.map(
              initial: (initial) => [
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                ),
              ],
              error: (error) => [
                const SliverFillRemaining(
                  child: Center(
                    child: Text('Error'),
                  ),
                ),
              ],
              noPermission: (noPermission) => [
                const SliverFillRemaining(
                  child: Center(
                    child: Text('No permission'),
                  ),
                ),
              ],
              loaded: (loaded) {
                return [
                  SongInfo(
                    cubit: cubit,
                    pageController: loaded.pageController,
                    songs: loaded.songs,
                    currentSong: loaded.currentSong,
                    loopMode: loaded.loopMode,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.twelve,
                    ),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Column(
                            children: [
                              SongPositionSlider(
                                duration: loaded.duration,
                                position: loaded.position,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacings.thirtyTwo),
                          PlayerControls(
                            cubit: cubit,
                            paused: loaded.paused,
                            currentSong: loaded.currentSong,
                            loopMode: loaded.loopMode,
                            isShuffle: loaded.isShuffle,
                          ),
                          const SizedBox(height: AppSpacings.sixtyFour),
                        ],
                      ),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}

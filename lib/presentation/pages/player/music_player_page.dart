import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/core/extension.dart';
import 'package:vibel/presentation/pages/player/cubit/music_player_cubit.dart';
import 'package:vibel/presentation/pages/player/widgets/song_position_slider.dart';
import 'package:vibel/presentation/shared/app_bar_widget.dart';
import 'package:vibel/presentation/shared/loading_indicator.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';
import 'package:vibel/presentation/styles/app_typography.dart';

class MusicPlayerPage extends HookWidget {
  const MusicPlayerPage({this.data, super.key});
  final (List<SongModel>, int, bool)? data;

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<MusicPlayerCubit>();
    final state = useBlocBuilder(cubit);

    final pageController = usePageController(
      initialPage: data?.$2 ?? 0,
    );
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
            context.pop(loaded.currentSong);
            return true;
          },
        );
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const AppBarWidget(title: 'Now playing'),
            state.map(
              initial: (initial) => const SliverToBoxAdapter(
                child: Center(
                  child: LoadingIndicator(),
                ),
              ),
              error: (error) => const SliverToBoxAdapter(
                child: Center(
                  child: Text('Error'),
                ),
              ),
              noPermission: (noPermission) => const SliverToBoxAdapter(
                child: Center(
                  child: Text('No permission'),
                ),
              ),
              loaded: (loaded) {
                final song = loaded.songs[loaded.currentSong];
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.twentyFour,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSpacings.sixtyFour),
                        SizedBox(
                          height: AppDimens.artworkDimensionBig,
                          child: PageView(
                            onPageChanged: (value) =>
                                cubit.next(prev: value < loaded.currentSong),
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var i = 0; i < loaded.songs.length; i++)
                                Center(
                                  child: ClipOval(
                                    child: SizedBox.square(
                                      dimension: AppDimens.artworkDimensionBig,
                                      child: QueryArtworkWidget(
                                        size: AppDimens.artworkDimensionBig
                                            .toInt(),
                                        keepOldArtwork: true,
                                        nullArtworkWidget: const Icon(
                                          FontAwesomeIcons.music,
                                          size: AppDimens.artworkIconSizeBig,
                                        ),
                                        quality: 100,
                                        controller: cubit.audioQuery,
                                        id: loaded.songs[i].id,
                                        type: ArtworkType.AUDIO,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacings.thirtyTwo),
                        Text(
                          song.title,
                          style: AppTypography.of(context).h3,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacings.twelve),
                        Text(
                          song.artistName,
                          style: AppTypography.of(context).h6,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacings.thirtyTwo),
                        SongPositionSlider(
                          duration: loaded.duration,
                          position: loaded.position,
                        ),
                        const SizedBox(height: AppSpacings.thirtyTwo),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.backwardStep,
                                size: 40,
                              ),
                              onPressed: () => cubit.next(prev: true),
                            ),
                            IconButton(
                              hoverColor: Colors.red,
                              icon: Icon(
                                loaded.paused
                                    ? FontAwesomeIcons.play
                                    : FontAwesomeIcons.pause,
                                size: 40,
                              ),
                              onPressed: () =>
                                  cubit.pauseorResume(loaded.currentSong),
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.forwardStep,
                                size: 40,
                              ),
                              onPressed: () => cubit.next(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

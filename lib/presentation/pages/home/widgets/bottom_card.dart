import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/core/extension.dart';
import 'package:vibel/domain/player/repeat_mode.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';
import 'package:vibel/presentation/pages/player/widgets/song_position_slider.dart';
import 'package:vibel/presentation/router/routes.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';
import 'package:vibel/presentation/styles/app_typography.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

class BottomCard extends HookWidget {
  const BottomCard({
    required this.cubit,
    required this.song,
    required this.currentSong,
    required this.paused,
    required this.songs,
    required this.pageController,
    required this.isShuffle,
    required this.repeatMode,
    super.key,
  });

  final HomeCubit cubit;
  final SongModel song;
  final int currentSong;
  final bool paused;
  final List<SongModel> songs;
  final PageController pageController;
  final bool isShuffle;
  final RepeatMode repeatMode;

  @override
  Widget build(BuildContext context) {
    // final pageController = usePageController(
    //   initialPage: currentSong,
    // );

    return Align(
      key: const Key('currentAudio'),
      alignment: Alignment.bottomCenter,
      child: SizedBox.fromSize(
        size: const Size.fromHeight(70),
        child: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: () async {
            cubit.musicPlayer();
            final (int, bool, RepeatMode)? data = await context.push(
              Routes.player,
              extra: (
                songs,
                currentSong,
                paused,
                isShuffle,
                repeatMode,
              ),
            );
            if (data != null) {
              cubit.updateAfterPlayerClosing(
                index: data.$1,
                isShuffle: data.$2,
                repeatMode: data.$3,
              );
            }
          },
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            color: context.colors.primary,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacings.eight,
                right: AppSpacings.eight,
                top: AppSpacings.twelve,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox.square(
                        dimension: 50,
                        child: QueryArtworkWidget(
                          keepOldArtwork: true,
                          nullArtworkWidget: const Icon(
                            FontAwesomeIcons.music,
                          ),
                          quality: 100,
                          controller: cubit.audioQuery,
                          id: song.id,
                          type: ArtworkType.AUDIO,
                        ),
                      ),
                      const SizedBox(width: AppSpacings.twelve),
                      SizedBox(
                        width: 220,
                        height: 50,
                        child: PageView.builder(
                          onPageChanged: (value) async {
                            cubit.playAudio(value);
                          },
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: repeatMode == RepeatMode.repeatAll
                              ? null
                              : songs.length,
                          itemBuilder: (context, index) {
                            index %= songs.length;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 220,
                                  height: 30,
                                  child: hasTextOverflow(
                                    songs[index].title,
                                    AppTypography.of(context).body,
                                    maxWidth: 220,
                                  )
                                      ? Marquee(
                                          blankSpace: AppSpacings.sixtyFour,
                                          text: songs[index].title,
                                          style: AppTypography.of(
                                            context,
                                          ).body,
                                        )
                                      : Text(
                                          songs[index].title,
                                          style: AppTypography.of(
                                            context,
                                          ).body,
                                        ),
                                ),
                                Text(
                                  songs[index].artistName,
                                  style: AppTypography.of(context).overline,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        splashRadius: AppDimens.iconButtonSplashRadius,
                        icon: Icon(
                          paused ? Icons.play_arrow : Icons.pause,
                        ),
                        onPressed: () {
                          cubit.clickOnSong(
                            currentSong,
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: SongPositionSlider(readOnly: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

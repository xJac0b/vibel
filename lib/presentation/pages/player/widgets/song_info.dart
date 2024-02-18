// ignore: unused_import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/core/extension.dart';
import 'package:vibel/domain/player/repeat_mode.dart';
import 'package:vibel/presentation/pages/player/cubit/music_player_cubit.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';
import 'package:vibel/presentation/styles/app_typography.dart';

class SongInfo extends StatelessWidget {
  const SongInfo({
    required this.cubit,
    required this.pageController,
    required this.songs,
    required this.currentSong,
    required this.repeatMode,
    super.key,
  });

  final MusicPlayerCubit cubit;
  final PageController pageController;
  final List<SongModel> songs;
  final int currentSong;
  final RepeatMode repeatMode;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.twelve,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            const SizedBox(height: AppSpacings.sixtyFour),
            SizedBox(
              height: AppDimens.artworkDimensionBig,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                onPageChanged: (value) async {
                  if (currentSong < value) {
                    cubit.nextButtonClicked();
                  } else {
                    cubit.prevButtonClicked();
                  }
                },
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount:
                    repeatMode == RepeatMode.repeatAll ? null : songs.length,
                itemBuilder: (context, index) {
                  index %= songs.length;
                  return Center(
                    child: ClipOval(
                      child: SizedBox.square(
                        dimension: AppDimens.artworkDimensionBig,
                        child: QueryArtworkWidget(
                          size: AppDimens.artworkDimensionBig.toInt(),
                          keepOldArtwork: true,
                          nullArtworkWidget: const Icon(
                            FontAwesomeIcons.music,
                            size: AppDimens.artworkIconSizeBig,
                          ),
                          quality: 100,
                          controller: cubit.audioQuery,
                          id: songs[index].id,
                          type: ArtworkType.AUDIO,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacings.thirtyTwo),
            Text(
              songs[currentSong].title,
              style: AppTypography.of(context).h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacings.twelve),
            Text(
              songs[currentSong].artistName,
              style: AppTypography.of(context).h6,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/core/extension.dart';
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
    super.key,
  });

  final MusicPlayerCubit cubit;
  final PageController pageController;
  final List<SongModel> songs;
  final int currentSong;

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
            child: PageView(
              physics: const BouncingScrollPhysics(),
              onPageChanged: (value) => cubit.next(prev: value < currentSong),
              controller: pageController,
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < songs.length; i++)
                  Center(
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
                          id: songs[i].id,
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
      ),),
    );
  }
}

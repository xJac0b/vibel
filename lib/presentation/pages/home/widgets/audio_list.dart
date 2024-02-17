import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/core/extension.dart';
import 'package:vibel/presentation/pages/home/cubit/home_cubit.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';
import 'package:vibel/presentation/styles/app_spacings.dart';
import 'package:vibel/presentation/styles/app_typography.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

class AudioList extends StatelessWidget {
  const AudioList({
    required this.audios,
    required this.searchBarText,
    required this.cubit,
    required this.currentSong,
    required this.paused,
    super.key,
  });
  final List<SongModel> audios;
  final String searchBarText;
  final HomeCubit cubit;
  final int currentSong;
  final bool paused;

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      initialItemCount: audios.length,
      itemBuilder: (context, index, animation) => !audios[index]
                  .title
                  .toLowerCase()
                  .contains(searchBarText.trim().toLowerCase()) &&
              !(audios[index].artist ?? '')
                  .toLowerCase()
                  .contains(searchBarText.trim().toLowerCase())
          ? const SizedBox.shrink()
          : Column(
              children: [
                InkWell(
                  onTap: () {
                    cubit.playAudio(index);
                  },
                  child: ListTile(
                    leading: Stack(
                      children: [
                        SizedBox.square(
                          dimension: AppDimens.artworkDimension,
                          child: QueryArtworkWidget(
                            keepOldArtwork: true,
                            nullArtworkWidget: const Icon(
                              FontAwesomeIcons.music,
                            ),
                            quality: 100,
                            controller: cubit.audioQuery,
                            id: audios[index].id,
                            type: ArtworkType.AUDIO,
                          ),
                        ),
                        if (currentSong == index)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              paused
                                  ? FontAwesomeIcons.solidCirclePlay
                                  : FontAwesomeIcons.solidCirclePause,
                              color: context.colors.primary,
                            ),
                          ),
                      ],
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audios[index].title,
                          style: AppTypography.of(context).body,
                        ),
                        Text(
                          audios[index].artistName,
                          style: AppTypography.of(context)
                              .overline
                              .copyWith(color: context.colors.hint),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                if (index == audios.length - 1)
                  const SizedBox(height: AppSpacings.eighty),
              ],
            ),
    );
  }
}

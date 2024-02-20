import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibel/presentation/pages/player/cubit/music_player_cubit.dart';
import 'package:vibel/presentation/styles/app_typography.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    required this.cubit,
    required this.paused,
    required this.currentSong,
    required this.loopMode,
    required this.isShuffle,
    super.key,
  });

  final MusicPlayerCubit cubit;
  final bool paused;
  final int currentSong;
  final LoopMode loopMode;
  final bool isShuffle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          alignment: Alignment.bottomLeft,
          icon: Icon(
            FontAwesomeIcons.shuffle,
            color: isShuffle ? context.colors.primary : context.colors.hint,
            size: 20,
          ),
          onPressed: () => cubit.shuffle(),
        ),
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.backwardStep,
            size: 40,
          ),
          onPressed: () => cubit.prevButtonClicked(),
        ),
        IconButton(
          hoverColor: Colors.red,
          icon: Icon(
            paused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
            size: 40,
          ),
          onPressed: () => cubit.pauseorResume(currentSong),
        ),
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.forwardStep,
            size: 40,
          ),
          onPressed: () => cubit.nextButtonClicked(),
        ),
        Stack(
          children: [
            IconButton(
              alignment: Alignment.bottomRight,
              icon: Icon(
                FontAwesomeIcons.repeat,
                color: switch (loopMode) {
                  LoopMode.off => context.colors.hint,
                  LoopMode.all => context.colors.primary,
                  LoopMode.one => context.colors.primary,
                },
                size: 20,
              ),
              onPressed: () => cubit.loop(),
            ),
            if (loopMode == LoopMode.one)
              Positioned(
                left: 5,
                bottom: 0,
                child: Text(
                  '1',
                  style: AppTypography.of(context)
                      .body
                      .copyWith(color: context.colors.primary),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

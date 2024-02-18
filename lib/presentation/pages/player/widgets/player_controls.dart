import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibel/presentation/pages/player/cubit/music_player_cubit.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    required this.cubit,
    required this.paused,
    required this.currentSong,
    super.key,
  });

  final MusicPlayerCubit cubit;
  final bool paused;
  final int currentSong;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          onPressed: () => cubit.next(),
        ),
      ],
    );
  }
}

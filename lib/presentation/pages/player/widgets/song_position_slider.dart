import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:vibel/presentation/pages/player/widgets/cubit/song_position_cubit.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

class SongPositionSlider extends HookWidget {
  const SongPositionSlider({
    required this.duration,
    required this.position,
    super.key,
  });
  final Duration duration;
  final Duration position;
  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<SongPositionCubit>();
    final state = useBlocBuilder(cubit);

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [],
    );
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 1,
        thumbColor: context.colors.primary,
        activeTrackColor: context.colors.primary,
        inactiveTrackColor: context.colors.hint,
      ),
      child: Slider(
        value: state.position?.inMilliseconds.toDouble() ??
            position.inMilliseconds.toDouble(),
        min: 0,
        max: state.duration?.inMilliseconds.toDouble() ??
            duration.inMilliseconds.toDouble(),
        onChanged: (value) {
          cubit.setPosition(Duration(milliseconds: value.toInt()));
        },
      ),
    );
  }
}

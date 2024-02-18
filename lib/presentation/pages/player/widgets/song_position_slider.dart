import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:vibel/presentation/pages/player/widgets/cubit/song_position_cubit.dart';
import 'package:vibel/presentation/styles/colors/app_colors.dart';

class SongPositionSlider extends HookWidget {
  const SongPositionSlider({
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.readOnly = false,
    super.key,
  });
  final Duration duration;
  final Duration position;
  final bool readOnly;
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
        overlayShape: SliderComponentShape.noOverlay,
        trackHeight: 2,
        thumbShape: readOnly ? SliderComponentShape.noThumb : null,
        thumbColor: context.colors.primary,
        activeTrackColor: context.colors.primary,
        inactiveTrackColor: context.colors.hint,
        disabledInactiveTrackColor: context.colors.hint.withOpacity(0.3),
        disabledActiveTrackColor: context.colors.hint.withOpacity(0.7),
      ),
      child: Slider(
        value: state.position?.inMilliseconds.toDouble() ??
            position.inMilliseconds.toDouble(),
        min: 0,
        max: state.duration?.inMilliseconds.toDouble() ??
            duration.inMilliseconds.toDouble(),
        onChanged: readOnly
            ? null
            : (value) {
                cubit.setPosition(Duration(milliseconds: value.toInt()));
              },
      ),
    );
  }
}

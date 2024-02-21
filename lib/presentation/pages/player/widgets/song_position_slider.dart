import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:vibel/core/extension.dart';
import 'package:vibel/presentation/pages/player/widgets/cubit/song_position_cubit.dart';
import 'package:vibel/presentation/styles/app_typography.dart';
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
      child: Column(
        children: [
          Slider(
            value: min(
              state.position?.inMilliseconds.toDouble() ??
                  position.inMilliseconds.toDouble(),
              state.duration?.inMilliseconds.toDouble() ??
                  duration.inMilliseconds.toDouble(),
            ),
            min: 0,
            max: state.duration?.inMilliseconds.toDouble() ??
                duration.inMilliseconds.toDouble(),
            onChanged: readOnly
                ? null
                : (value) {
                    cubit.setPosition(Duration(milliseconds: value.toInt()));
                  },
          ),
          if (!readOnly)
            Builder(
              builder: (context) {
                final pos = state.position ?? position;
                final dur = state.duration ?? duration;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pos.format(),
                      style: AppTypography.of(context).subtitleSmall.copyWith(),
                    ),
                    Text(
                      dur.format(),
                      style: AppTypography.of(context).subtitleSmall.copyWith(),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

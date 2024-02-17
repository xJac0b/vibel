import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';

part 'song_position_state.dart';
part 'song_position_cubit.freezed.dart';

@inject
class SongPositionCubit extends Cubit<SongPositionState> {
  SongPositionCubit(this.audioPlayer)
      : super(
          const SongPositionState(
            position: null,
            duration: null,
          ),
        );

  final AudioPlayer audioPlayer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  Future<void> init() async {
    emit(
      SongPositionState(
        duration: await audioPlayer.getDuration() ?? Duration.zero,
        position: await audioPlayer.getCurrentPosition() ?? Duration.zero,
      ),
    );
    _positionSubscription = audioPlayer.onPositionChanged.listen(
      (event) {
        emit(state.copyWith(position: event));
      },
    );
    _durationSubscription = audioPlayer.onDurationChanged.listen(
      (event) {
        emit(state.copyWith(duration: event));
      },
    );
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    return super.close();
  }

  void setPosition(Duration duration) {
    audioPlayer.seek(duration);
  }
}

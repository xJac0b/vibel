import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/use_cases/get_duration_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_position_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_duration_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_position_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/seek_use_case.dart';

part 'song_position_cubit.freezed.dart';
part 'song_position_state.dart';

@inject
class SongPositionCubit extends Cubit<SongPositionState> {
  SongPositionCubit(
    this._getDurationUseCase,
    this._getPositionUseCase,
    this._onPositionChangedUseCase,
    this._onDurationChangedUseCase,
    this._seekUseCase,
  ) : super(
          const SongPositionState(
            position: null,
            duration: null,
          ),
        );

  final GetDurationUseCase _getDurationUseCase;
  final GetPositionUseCase _getPositionUseCase;
  final OnPositionChangedUseCase _onPositionChangedUseCase;
  final OnDurationChangedUseCase _onDurationChangedUseCase;
  final SeekUseCase _seekUseCase;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;

  Future<void> init() async {
    emit(
      SongPositionState(
        duration: _getDurationUseCase() ?? Duration.zero,
        position: _getPositionUseCase() ?? Duration.zero,
      ),
    );
    _positionSubscription = _onPositionChangedUseCase().listen(
      (event) {
        emit(state.copyWith(position: event));
      },
    );
    _durationSubscription = _onDurationChangedUseCase().listen(
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
    _seekUseCase(duration);
  }
}

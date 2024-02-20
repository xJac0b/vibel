import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/domain/audio_player/loop_mode_x.dart';
import 'package:vibel/domain/audio_player/use_cases/get_duration_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_loop_mode_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_player_state_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_position_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_shuffle_mode_enabled_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_current_index_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_loop_mode_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_player_state_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_shuffle_mode_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/pause_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/play_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/seek_next_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/seek_previous_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/seek_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/set_loop_mode_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/set_shuffle_mode_enabled_use_case.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';

part 'music_player_cubit.freezed.dart';
part 'music_player_state.dart';

@inject
class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  MusicPlayerCubit(
    this.audioQuery,
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._onPlayerStateChangedUseCase,
    this._playerState,
    this._getDurationUseCase,
    this._getPositionUseCase,
    this._getShuffleModeEnabledUseCase,
    this._getLoopModeUseCase,
    this._onCurrentIndexChangedUseCase,
    this._seekNextUseCase,
    this._seekPreviousUseCase,
    this._onShuffleModeChangedUseCase,
    this._onLoopModeChangedUseCase,
    this._seekUseCase,
    this._setShuffleModeEnabledUseCase,
    this._setLoopModeUseCase,
  ) : super(const MusicPlayerState.initial()) {
    _indexStreamSubscription = _onCurrentIndexChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (loaded) {
          if (event == null) {
            emit(const MusicPlayerState.error());
          } else {
            emit(loaded.copyWith(currentSong: event));
            if (loaded.pageController.hasClients) {
              loaded.pageController.animateToPage(
                event,
                duration: AppDimens.mediumAnimation,
                curve: Curves.easeInOut,
              );
            }
          }
        },
      );
    });
    _playerStateSubscription = _onPlayerStateChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (value) {
          emit(value.copyWith(paused: !event.playing));
        },
      );
    });
    _shuffleModeSubscription = _onShuffleModeChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (value) {
          emit(value.copyWith(isShuffle: event));
        },
      );
    });
    _loopModeSubscription = _onLoopModeChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (value) {
          emit(value.copyWith(loopMode: event));
        },
      );
    });
  }

  final OnAudioQuery audioQuery;
  StreamSubscription<int?>? _indexStreamSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<bool>? _shuffleModeSubscription;
  StreamSubscription<LoopMode>? _loopModeSubscription;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final OnPlayerStateChangedUseCase _onPlayerStateChangedUseCase;
  final GetPlayerStateUseCase _playerState;
  final GetDurationUseCase _getDurationUseCase;
  final GetPositionUseCase _getPositionUseCase;
  final GetShuffleModeEnabledUseCase _getShuffleModeEnabledUseCase;
  final GetLoopModeUseCase _getLoopModeUseCase;
  final OnCurrentIndexChangedUseCase _onCurrentIndexChangedUseCase;
  final SeekNextUseCase _seekNextUseCase;
  final SeekPreviousUseCase _seekPreviousUseCase;
  final OnShuffleModeChangedUseCase _onShuffleModeChangedUseCase;
  final OnLoopModeChangedUseCase _onLoopModeChangedUseCase;
  final SeekUseCase _seekUseCase;
  final SetShuffleModeEnabledUseCase _setShuffleModeEnabledUseCase;
  final SetLoopModeUseCase _setLoopModeUseCase;

  Future<void> init({
    required List<SongModel> songs,
    required int currentSong,
    required bool paused,
  }) async {
    emit(
      MusicPlayerState.loaded(
        songs: songs,
        currentSong: currentSong,
        paused: paused,
        duration: _getDurationUseCase() ?? Duration.zero,
        position: _getPositionUseCase() ?? Duration.zero,
        isShuffle: _getShuffleModeEnabledUseCase(),
        loopMode: _getLoopModeUseCase(),
        pageController: PageController(initialPage: currentSong),
      ),
    );
  }

  void nextButtonClicked() => _seekNextUseCase();

  void prevButtonClicked() => _seekPreviousUseCase();

  void pauseorResume(int index) {
    state.mapOrNull(
      loaded: (loaded) async {
        if (_playerState().playing) {
          await _pauseAudioUseCase();
        } else {
          await _playAudioUseCase();
        }
      },
    );
  }

  void playAudio(int index) {
    state.mapOrNull(
      loaded: (loaded) async {
        if (loaded.currentSong == index) return;
        final newIndex = index % loaded.songs.length;
        await _seekUseCase(Duration.zero, newIndex);
      },
    );
  }

  void shuffle() {
    state.mapOrNull(
      loaded: (loaded) async =>
          _setShuffleModeEnabledUseCase(enabled: !loaded.isShuffle),
    );
  }

  void loop() {
    state.mapOrNull(
      loaded: (loaded) => _setLoopModeUseCase(loaded.loopMode.next()),
    );
  }

  Future<Duration?> getDuration() async {
    return _getDurationUseCase();
  }

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _indexStreamSubscription?.cancel();
    await _shuffleModeSubscription?.cancel();
    await _loopModeSubscription?.cancel();
    return super.close();
  }
}

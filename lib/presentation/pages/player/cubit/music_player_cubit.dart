import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/domain/audio_player/repeat_mode.dart';
import 'package:vibel/domain/audio_player/use_cases/audio_source_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_duration_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_position_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_player_state_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/pause_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/play_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/player_state_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/resume_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/seek_audio_use_case.dart';
import 'package:vibel/presentation/styles/app_dimens.dart';

part 'music_player_cubit.freezed.dart';
part 'music_player_state.dart';

@inject
class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  MusicPlayerCubit(
    this.audioQuery,
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._seekAudioUseCase,
    this._onPlayerStateChangedUseCase,
    this._resumeAudioUseCase,
    this._playerState,
    this._audioSource,
    this._getDurationUseCase,
    this._getPositionUseCase,
  ) : super(const MusicPlayerState.initial()) {
    _playerStateSubscription = _onPlayerStateChangedUseCase().listen((event) {
      if (event == PlayerState.stopped || event == PlayerState.paused) {
        state.mapOrNull(
          loaded: (value) {
            emit(value.copyWith(paused: true));
          },
        );
      } else if (event == PlayerState.completed) {
        onCompleted();
      } else if (event == PlayerState.playing) {
        state.mapOrNull(
          loaded: (value) {
            emit(value.copyWith(paused: false));
          },
        );
      }
    });
  }

  final OnAudioQuery audioQuery;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final SeekAudioUseCase _seekAudioUseCase;
  final OnPlayerStateChangedUseCase _onPlayerStateChangedUseCase;
  final ResumeAudioUseCase _resumeAudioUseCase;
  final PlayerStateUseCase _playerState;
  final AudioSourceUseCase _audioSource;
  final GetDurationUseCase _getDurationUseCase;
  final GetPositionUseCase _getPositionUseCase;

  Future<void> init({
    required List<SongModel> songs,
    required int currentSong,
    required bool paused,
    required bool isShuffle,
    required RepeatMode repeatMode,
  }) async {
    emit(
      MusicPlayerState.loaded(
        songs: songs,
        currentSong: currentSong,
        paused: paused,
        duration: await _getDurationUseCase() ?? Duration.zero,
        position: await _getPositionUseCase() ?? Duration.zero,
        isShuffle: isShuffle,
        repeatMode: repeatMode,
        pageController: PageController(initialPage: currentSong),
      ),
    );
  }

  void nextButtonClicked() {
    state.mapOrNull(
      loaded: (loaded) async {
        int newIndex = loaded.currentSong;
        RepeatMode repeatMode = loaded.repeatMode;
        if (loaded.currentSong >= loaded.songs.length - 1 &&
            repeatMode == RepeatMode.repeatAll) {
          newIndex = 0;
        } else {
          newIndex++;
          if (repeatMode == RepeatMode.repeatOne) {
            repeatMode = RepeatMode.repeatAll;
          }
        }
        if (newIndex == loaded.currentSong) {
          await _seekAudioUseCase(Duration.zero);
          await _pauseAudioUseCase();
        } else {
          if (newIndex > 0) {
            await loaded.pageController.animateToPage(
              newIndex,
              duration: AppDimens.pageViewAnimationDuration,
              curve: Curves.easeIn,
            );
          } else {
            loaded.pageController.jumpToPage(newIndex);
          }
        }
      },
    );
  }

  void prevButtonClicked() {
    state.mapOrNull(
      loaded: (loaded) async {
        final newIndex = loaded.currentSong <= 0 ? 0 : loaded.currentSong - 1;
        if (loaded.currentSong == 0) await _seekAudioUseCase(Duration.zero);
        await loaded.pageController.animateToPage(
          newIndex,
          duration: AppDimens.pageViewAnimationDuration,
          curve: Curves.easeIn,
        );
      },
    );
  }

  void playAudio(int index) {
    state.mapOrNull(
      loaded: (loaded) async {
        final newIndex = index % loaded.songs.length;
        await _playAudioUseCase(loaded.songs[newIndex].data);
        emit(
          loaded.copyWith(
            currentSong: newIndex,
            position: Duration.zero,
            duration: await _getDurationUseCase() ?? Duration.zero,
            paused: loaded.repeatMode != RepeatMode.repeatAll &&
                loaded.currentSong == loaded.songs.length - 1 &&
                loaded.currentSong == newIndex,
          ),
        );
      },
    );
  }

  void pauseorResume(int index) {
    state.mapOrNull(
      loaded: (loaded) {
        if (_audioSource() == null) {
          _playAudioUseCase(loaded.songs[index].data);
          return;
        }
        if (loaded.paused) {
          if (_playerState() == PlayerState.completed) {
            _playAudioUseCase(loaded.songs[index].data);
          } else {
            _resumeAudioUseCase();
          }
          return;
        } else {
          _pauseAudioUseCase();
          return;
        }
      },
    );
  }

  void shuffle() {
    state.mapOrNull(
      loaded: (loaded) {
        emit(
          loaded.copyWith(
            isShuffle: !loaded.isShuffle,
          ),
        );
      },
    );
  }

  void repeat() {
    state.mapOrNull(
      loaded: (loaded) {
        final temp = loaded.repeatMode.next();
        emit(
          loaded.copyWith(
            repeatMode: temp,
          ),
        );
      },
    );
  }

  Future<Duration?> getDuration() async {
    return await _getDurationUseCase();
  }

  void onCompleted() {
    state.mapOrNull(
      loaded: (loaded) async {
        if (loaded.repeatMode == RepeatMode.repeatOne) {
          await _seekAudioUseCase(Duration.zero);
          await _playAudioUseCase(loaded.songs[loaded.currentSong].data);
        } else {
          nextButtonClicked();
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    return super.close();
  }
}

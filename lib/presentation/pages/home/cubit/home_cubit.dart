import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/domain/audio_player/use_cases/get_current_index_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/get_player_state_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_current_index_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_loop_mode_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_player_state_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_shuffle_mode_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/pause_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/play_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/release_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/seek_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/set_audio_source_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/stop_audio_use_case.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@inject
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this.audioQuery,
    this._playAudioUseCase,
    this._pauseAudioUseCase,
    this._stopAudioUseCase,
    this._seekUseCase,
    this._releaseAudioUseCase,
    this._onPlayerStateChangedUseCase,
    this._setAudioSourceUseCase,
    this._playerState,
    this._onCurrentIndexChangedUseCase,
    this._onShuffleModeChangedUseCase,
    this._onLoopModeChangedUseCase,
    this._getCurrentIndexUseCase,
  ) : super(const HomeState.initial()) {
    _onCurrentIndexChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (loaded) async {
          if (event != null && loaded.currentSong != event) {
            loaded.bottomCardController.jumpToPage(event);
            state.mapOrNull(
              loaded: (value) {
                emit(
                  value.copyWith(
                    currentSong: event,
                  ),
                );
              },
            );
          }
        },
      );
    });
    _onPlayerStateChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (value) {
          emit(value.copyWith(paused: !event.playing));
        },
      );
    });
    _onShuffleModeChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (value) {
          emit(value.copyWith(isShuffle: event));
        },
      );
    });
    _onLoopModeChangedUseCase().listen((event) {
      state.mapOrNull(
        loaded: (value) {
          emit(value.copyWith(loopMode: event));
        },
      );
    });
  }

  final OnAudioQuery audioQuery;
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final SeekUseCase _seekUseCase;
  final ReleaseAudioUseCase _releaseAudioUseCase;
  final OnPlayerStateChangedUseCase _onPlayerStateChangedUseCase;
  final SetAudioSourceUseCase _setAudioSourceUseCase;
  final GetPlayerStateUseCase _playerState;
  final OnCurrentIndexChangedUseCase _onCurrentIndexChangedUseCase;
  final OnShuffleModeChangedUseCase _onShuffleModeChangedUseCase;
  final OnLoopModeChangedUseCase _onLoopModeChangedUseCase;
  final GetCurrentIndexUseCase _getCurrentIndexUseCase;

  Future<void> requestPermission() async {
    await audioQuery.permissionsRequest(retryRequest: true);
    await loadAudios();
  }

  Future<void> loadAudios() async {
    if (!await audioQuery.checkAndRequest(retryRequest: true)) {
      emit(const HomeState.noPermission());
      return;
    }
    final audios = await audioQuery.querySongs();
    await _setAudioSourceUseCase(audios);
    emit(
      HomeState.loaded(
        songs: audios,
        currentSong: null,
        paused: true,
        bottomCardController: PageController(initialPage: 0),
        isShuffle: false,
        loopMode: LoopMode.off,
        musicPlayerOpen: false,
      ),
    );
  }

  void musicPlayer() {
    state.mapOrNull(
      loaded: (value) {
        emit(
          value.copyWith(
            musicPlayerOpen: true,
          ),
        );
      },
    );
  }

  void closeMusicPlayer() {
    state.mapOrNull(
      loaded: (value) {
        emit(
          value.copyWith(
            musicPlayerOpen: false,
          ),
        );
      },
    );
  }

  void clickOnSong(int index) {
    state.mapOrNull(
      loaded: (loaded) async {
        if (loaded.currentSong == index) {
          if (_playerState().playing) {
            await _pauseAudioUseCase();
          } else {
            await _playAudioUseCase();
          }
        } else {
          if (loaded.currentSong == null && index == 0) {
            playAudio(index);
            emit(loaded.copyWith(currentSong: index));
          } else {
            loaded.bottomCardController.jumpToPage(index);
          }
        }
      },
    );
  }

  void playAudio(int index) {
    state.mapOrNull(
      loaded: (loaded) async {
        final newIndex = index % loaded.songs.length;
        if (loaded.musicPlayerOpen ||
            loaded.currentSong == newIndex ||
            _getCurrentIndexUseCase() == newIndex) return;

        emit(
          loaded.copyWith(
            currentSong: newIndex,
          ),
        );

        await _seekUseCase(Duration.zero, newIndex);
        await _playAudioUseCase();
      },
    );
  }

  @override
  Future<void> close() async {
    await _stopAudioUseCase();
    await _releaseAudioUseCase();
    return super.close();
  }
}

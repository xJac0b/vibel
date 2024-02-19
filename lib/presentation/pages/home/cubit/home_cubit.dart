import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/domain/audio_player/repeat_mode.dart';
import 'package:vibel/domain/audio_player/use_cases/audio_source_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_player_complete_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/on_player_state_changed_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/pause_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/play_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/player_state_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/release_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/resume_audio_use_case.dart';
import 'package:vibel/domain/audio_player/use_cases/seek_audio_use_case.dart';
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
    this._seekAudioUseCase,
    this._releaseAudioUseCase,
    this._onPlayerStateChangedUseCase,
    this._onPlayerCompleteUseCase,
    this._resumeAudioUseCase,
    this._playerState,
    this._audioSource,
  ) : super(const HomeState.initial()) {
    _onPlayerCompleteUseCase().listen((event) {
      state.mapOrNull(
        loaded: (loaded) {
          if (!loaded.musicPlayerOpen) onCompleted();
        },
      );
    });
    _onPlayerStateChangedUseCase().listen((event) {
      if (event == PlayerState.stopped || event == PlayerState.paused) {
        state.mapOrNull(
          loaded: (value) {
            emit(value.copyWith(paused: true));
          },
        );
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
  final PlayAudioUseCase _playAudioUseCase;
  final PauseAudioUseCase _pauseAudioUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final SeekAudioUseCase _seekAudioUseCase;
  final ReleaseAudioUseCase _releaseAudioUseCase;
  final OnPlayerStateChangedUseCase _onPlayerStateChangedUseCase;
  final OnPlayerCompleteUseCase _onPlayerCompleteUseCase;
  final ResumeAudioUseCase _resumeAudioUseCase;
  final PlayerStateUseCase _playerState;
  final AudioSourceUseCase _audioSource;

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
    emit(
      HomeState.loaded(
        songs: audios,
        currentSong: 0,
        paused: true,
        bottomCardController: PageController(initialPage: 0),
        isShuffle: false,
        repeatMode: RepeatMode.noRepeat,
        musicPlayerOpen: false,
      ),
    );
  }

  void musicPlayer() {
    state.mapOrNull(
      loaded: (value) {
        emit(value.copyWith(musicPlayerOpen: true));
      },
    );
  }

  void sortAlphabetically({bool reverse = false}) {
    state.mapOrNull(
      loaded: (value) {
        final previousPlayingId = value.songs[value.currentSong].id;
        final sorted = value.songs.toList()
          ..sort(
            (a, b) => reverse
                ? b.title.toLowerCase().compareTo(a.title.toLowerCase())
                : a.title.toLowerCase().compareTo(b.title.toLowerCase()),
          );
        final newIndex =
            sorted.indexWhere((element) => previousPlayingId == element.id);
        emit(
          value.copyWith(
            songs: sorted,
            currentSong: newIndex,
          ),
        );
        value.bottomCardController.jumpToPage(newIndex);
      },
    );
  }

  void updateAfterPlayerClosing({
    required int index,
    required bool isShuffle,
    required RepeatMode repeatMode,
  }) {
    state.mapOrNull(
      loaded: (value) {
        if (value.bottomCardController.page?.toInt() != index) {
          value.bottomCardController.jumpToPage(index);
        }
        emit(
          value.copyWith(
            currentSong: index,
            isShuffle: isShuffle,
            repeatMode: repeatMode,
            musicPlayerOpen: false,
          ),
        );
      },
    );
  }

  void clickOnSong(int index) {
    state.mapOrNull(
      loaded: (loaded) async {
        if (_audioSource() != null && loaded.currentSong == index) {
          if (loaded.paused) {
            await _resumeAudioUseCase();
            return;
          } else {
            await _pauseAudioUseCase();
            return;
          }
        }
        loaded.bottomCardController.jumpToPage(index);
        if (index == loaded.currentSong) playAudio(index);
      },
    );
  }

  void playAudio(int index) {
    state.mapOrNull(
      loaded: (loaded) async {
        if (loaded.musicPlayerOpen) return;
        final newIndex = index % loaded.songs.length;
        await _playAudioUseCase(loaded.songs[newIndex].data);
        emit(
          loaded.copyWith(
            currentSong: newIndex,
            paused: false,
          ),
        );
      },
    );
  }

  void nextSong() {
    state.mapOrNull(
      loaded: (loaded) async {
        int newIndex = loaded.currentSong;
        bool pause = false;
        RepeatMode repeatMode = loaded.repeatMode;
        if (loaded.currentSong >= loaded.songs.length - 1) {
          switch (loaded.repeatMode) {
            case RepeatMode.noRepeat || RepeatMode.repeatOne:
              pause = true;
            case RepeatMode.repeatAll:
              newIndex = 0;
          }
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
          final song = loaded.songs[newIndex].data;
          await _playAudioUseCase(song);
        }

        emit(
          loaded.copyWith(
            paused: pause,
            currentSong: newIndex,
            repeatMode: repeatMode,
          ),
        );
      },
    );
  }

  void onCompleted() {
    state.mapOrNull(
      loaded: (loaded) async {
        if (loaded.repeatMode == RepeatMode.repeatOne) {
          await _seekAudioUseCase(Duration.zero);
          await _playAudioUseCase(loaded.songs[loaded.currentSong].data);
        } else {
          nextSong();
        }
      },
    );
  }

  @override
  Future<void> close() async {
    if (_playerState() == PlayerState.playing) await _stopAudioUseCase();
    await _releaseAudioUseCase();
    return super.close();
  }
}

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/domain/player/repeat_mode.dart';

part 'music_player_cubit.freezed.dart';
part 'music_player_state.dart';

@inject
class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  MusicPlayerCubit(this.audioPlayer, this.audioQuery)
      : super(const MusicPlayerState.initial()) {
    _playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((event) {
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

  final AudioPlayer audioPlayer;
  final OnAudioQuery audioQuery;
  StreamSubscription<PlayerState>? _playerStateSubscription;

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
        duration: await audioPlayer.getDuration() ?? Duration.zero,
        position: await audioPlayer.getCurrentPosition() ?? Duration.zero,
        isShuffle: isShuffle,
        repeatMode: repeatMode,
      ),
    );
  }

  void nextButtonClicked() {
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
        if (pause) {
          await audioPlayer.stop();
        }
        final song = loaded.songs[newIndex].data;
        await audioPlayer.play(DeviceFileSource(song));
        if (pause) {
          await audioPlayer.pause();
        }
        emit(
          loaded.copyWith(
            paused: pause,
            currentSong: newIndex,
            repeatMode: repeatMode,
            position: Duration.zero,
            duration: await audioPlayer.getDuration() ?? Duration.zero,
          ),
        );
      },
    );
  }

  void prevButtonClicked() {
    state.mapOrNull(
      loaded: (loaded) async {
        final newIndex = loaded.currentSong <= 0 ? 0 : loaded.currentSong - 1;
        final song = loaded.songs[newIndex].data;
        if (loaded.currentSong == 0) await audioPlayer.seek(Duration.zero);
        await audioPlayer.play(DeviceFileSource(song));
        emit(
          loaded.copyWith(
            currentSong: newIndex,
            position: Duration.zero,
            paused: false,
          ),
        );
      },
    );
  }

  void pauseorResume(int index) {
    state.mapOrNull(
      loaded: (loaded) {
        if (audioPlayer.source == null) {
          audioPlayer.play(DeviceFileSource(loaded.songs[index].data));
          return;
        }
        if (loaded.paused) {
          if (audioPlayer.state == PlayerState.completed) {
            audioPlayer.play(DeviceFileSource(loaded.songs[index].data));
          } else {
            audioPlayer.resume();
          }
          return;
        } else {
          audioPlayer.pause();
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
    return await audioPlayer.getDuration();
  }

  void onCompleted() {
    state.mapOrNull(
      loaded: (loaded) async {
        if (loaded.repeatMode == RepeatMode.repeatOne) {
          await audioPlayer.seek(Duration.zero);
          await audioPlayer
              .play(DeviceFileSource(loaded.songs[loaded.currentSong].data));
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

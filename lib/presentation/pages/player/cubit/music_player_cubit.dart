import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'music_player_cubit.freezed.dart';
part 'music_player_state.dart';

@inject
class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  MusicPlayerCubit(this.audioPlayer, this.audioQuery)
      : super(const MusicPlayerState.initial()) {
    _playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.stopped ||
          event == PlayerState.paused ||
          event == PlayerState.completed) {
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

  final AudioPlayer audioPlayer;
  final OnAudioQuery audioQuery;
  StreamSubscription<PlayerState>? _playerStateSubscription;

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
        duration: await audioPlayer.getDuration() ?? Duration.zero,
        position: await audioPlayer.getCurrentPosition() ?? Duration.zero,
      ),
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

  Future<Duration?> getDuration() async {
    return await audioPlayer.getDuration();
  }

  void next({bool prev = false}) {
    state.mapOrNull(
      loaded: (loaded) async {
        final nextIndex = loaded.currentSong + (prev ? -1 : 1);
        if (nextIndex < loaded.songs.length && nextIndex >= 0) {
          final song = loaded.songs[nextIndex].data;
          Future.delayed(
            const Duration(milliseconds: 500),
            () => audioPlayer.play(DeviceFileSource(song)),
          );
          emit(
            loaded.copyWith(
              currentSong: nextIndex,
              paused: false,
              position: Duration.zero,
            ),
          );
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

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@inject
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.audioQuery, this.audioPlayer)
      : super(const HomeState.initial()) {
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed ||
          event == PlayerState.stopped ||
          event == PlayerState.paused) {
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
  final AudioPlayer audioPlayer;

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
      ),
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
        emit(
          value.copyWith(
            songs: sorted,
            currentSong:
                sorted.indexWhere((element) => previousPlayingId == element.id),
          ),
        );
      },
    );
  }

  void updateIndex(int index) {
    state.mapOrNull(
      loaded: (value) {
        value.bottomCardController.jumpToPage(index);
        emit(value.copyWith(currentSong: index));
      },
    );
  }

  void playAudio(int index) {
    state.mapOrNull(
      loaded: (loaded) {
        if (audioPlayer.source != null && loaded.currentSong == index) {
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
        }
        final audio = loaded.songs[index].data;
        loaded.bottomCardController.jumpToPage(index);
        audioPlayer.play(DeviceFileSource(audio));
        emit(
          loaded.copyWith(
            currentSong: index,
            paused: false,
          ),
        );
      },
    );
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
            ),
          );
        }
      },
    );
  }

  void setVolume(double volume) {
    audioPlayer.setVolume(volume);
  }

  @override
  Future<void> close() async {
    if (audioPlayer.state == PlayerState.playing) await audioPlayer.stop();
    await audioPlayer.release();
    return super.close();
  }
}

part of 'music_player_cubit.dart';

@freezed
class MusicPlayerState with _$MusicPlayerState {
  const factory MusicPlayerState.initial() = _Initial;
  const factory MusicPlayerState.loaded({
    required List<SongModel> songs,
    required int currentSong,
    required bool paused,
    required Duration duration,
    required Duration position,
    required bool isShuffle,
    required RepeatMode repeatMode,
    required PageController pageController,
  }) = _Loaded;
  const factory MusicPlayerState.noPermission() = _NoPermission;
  const factory MusicPlayerState.error() = _Error;
}

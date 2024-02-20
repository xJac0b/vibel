part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loaded({
    required List<SongModel> songs,
    required int? currentSong,
    required bool paused,
    required PageController bottomCardController,
    required bool isShuffle,
    required LoopMode loopMode,
    required bool musicPlayerOpen,
  }) = _Loaded;
  const factory HomeState.noPermission() = _NoPermission;
}

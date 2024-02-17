part of 'song_position_cubit.dart';

@freezed
class SongPositionState with _$SongPositionState {
  const factory SongPositionState({
    required Duration? duration,
    required Duration? position,
  }) = _SongPositionState;
}

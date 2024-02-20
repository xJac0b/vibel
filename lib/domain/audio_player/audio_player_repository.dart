import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class AudioPlayerRepository {
  Future<void> setAudioSource(List<SongModel> songs);
  Future<void> play();
  Future<void> seek(Duration position, int? index);
  Stream<int?> get currentIndexStream;
  Future<void> seekNext();
  Future<void> seekPrevious();
  Future<void> setLoopMode(LoopMode mode);
  Future<void> setShuffleModeEnabled({required bool enabled});
  Stream<bool> get shuffleModeEnabledStream;
  Stream<LoopMode> get loopModeStream;
  LoopMode get loopMode;
  bool get shuffleModeEnabled;
  Future<void> pause();
  Future<void> stop();
  PlayerState get playerState;
  AudioSource? get audioSource;
  Duration? getDuration();
  Duration? getPosition();
  Stream<Duration?> get onDurationChanged;
  Stream<Duration> get onPositionChanged;
  Stream<PlayerState> get onPlayerStateChanged;
  Future<void> dispose();
}

import 'package:audioplayers/audioplayers.dart';

abstract class AudioPlayerRepository {
  Future<void> play(String path);
  Future<void> pause();
  Future<void> stop();
  Future<void> seekTo(Duration position);
  Future<void> resume();
  PlayerState get playerState;
  Source? get audioSource;
  Future<Duration?> getDuration();
  Future<Duration?> getPosition();
  Stream<Duration> get onDurationChanged;
  Stream<Duration> get onPositionChanged;
  Stream<PlayerState> get onPlayerStateChanged;
  Stream<void> get onPlayerComplete;
  Future<void> release();
}

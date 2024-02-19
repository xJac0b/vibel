import 'package:audioplayers/audioplayers.dart';
import 'package:injecteo/injecteo.dart';

@singleton
class AudioPlayerDataSource {
  AudioPlayerDataSource(this.audioPlayer);
  final AudioPlayer audioPlayer;

  Future<void> play(String path) async {
    await audioPlayer.play(DeviceFileSource(path));
  }

  Future<void> pause() async => await audioPlayer.pause();

  Future<void> stop() async => await audioPlayer.stop();

  Future<void> seekTo(Duration position) async =>
      await audioPlayer.seek(position);

  Future<void> resume() async => await audioPlayer.resume();

  Future<Duration?> getDuration() async => await audioPlayer.getDuration();
  Future<Duration?> getPosition() async =>
      await audioPlayer.getCurrentPosition();
  PlayerState get playerState => audioPlayer.state;
  Source? get audioSource => audioPlayer.source;

  Stream<Duration> get onDurationChanged => audioPlayer.onDurationChanged;
  Stream<Duration> get onPositionChanged => audioPlayer.onPositionChanged;
  Stream<PlayerState> get onPlayerStateChanged =>
      audioPlayer.onPlayerStateChanged;
  Stream<void> get onPlayerComplete => audioPlayer.onPlayerComplete;
  Future<void> release() async {
    await audioPlayer.release();
  }
}

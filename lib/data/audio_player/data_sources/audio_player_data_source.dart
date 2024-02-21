import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

@singleton
class AudioPlayerDataSource {
  AudioPlayerDataSource(this.audioPlayer);
  final AudioPlayer audioPlayer;

  Future<void> setAudioSource(List<SongModel> songs) async {
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: songs.indexed
          .map(
            (e) => AudioSource.uri(
              Uri.file(e.$2.data),
              tag: MediaItem(
                id: '${e.$1}',
                title: e.$2.title,
                // artUri: Uri.parse(e.$2.data),
              ),
            ),
          )
          .toList(),
    );

    await audioPlayer.setAudioSource(
      playlist,
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
  }

  Future<void> play() async {
    await audioPlayer.play();
  }

  Future<void> seek(Duration position, int? index) async {
    await audioPlayer.seek(position, index: index ?? audioPlayer.currentIndex);
  }

  Stream<int?> get currentIndexStream => audioPlayer.currentIndexStream;

  Stream<LoopMode> get loopModeStream => audioPlayer.loopModeStream;

  Stream<bool> get shuffleModeEnabledStream =>
      audioPlayer.shuffleModeEnabledStream;

  Future<void> seekNext() => audioPlayer.seekToNext();

  Future<void> seekPrevious() => audioPlayer.seekToPrevious();

  Future<void> setLoopMode(LoopMode mode) => audioPlayer.setLoopMode(mode);

  Future<void> setShuffleModeEnabled({required bool enabled}) =>
      audioPlayer.setShuffleModeEnabled(enabled);

  LoopMode get loopMode => audioPlayer.loopMode;

  bool get shuffleModeEnabled => audioPlayer.shuffleModeEnabled;

  Future<void> pause() async => await audioPlayer.pause();

  Future<void> stop() async => await audioPlayer.stop();

  Duration? getDuration() => audioPlayer.duration;
  Duration? getPosition() => audioPlayer.position;
  PlayerState get playerState => audioPlayer.playerState;
  AudioSource? get audioSource => audioPlayer.audioSource;

  Stream<Duration?> get onDurationChanged => audioPlayer.durationStream;
  Stream<Duration> get onPositionChanged => audioPlayer.positionStream;
  Stream<PlayerState> get onPlayerStateChanged => audioPlayer.playerStateStream;
  Future<void> dispose() async {
    await audioPlayer.dispose();
  }
}

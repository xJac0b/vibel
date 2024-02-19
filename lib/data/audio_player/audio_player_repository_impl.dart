import 'package:audioplayers/audioplayers.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/data/audio_player/data_sources/audio_player_data_source.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@Singleton(as: AudioPlayerRepository)
class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  AudioPlayerRepositoryImpl(this._audioPlayerDataSource);
  final AudioPlayerDataSource _audioPlayerDataSource;

  @override
  Future<void> play(String path) async =>
      await _audioPlayerDataSource.play(path);

  @override
  Future<void> pause() async => await _audioPlayerDataSource.pause();

  @override
  Future<void> stop() async => await _audioPlayerDataSource.stop();

  @override
  Future<void> seekTo(Duration position) async =>
      await _audioPlayerDataSource.seekTo(position);

  @override
  Future<void> resume() async => await _audioPlayerDataSource.resume();

  @override
  PlayerState get playerState => _audioPlayerDataSource.playerState;

  @override
  Source? get audioSource => _audioPlayerDataSource.audioSource;

  @override
  Stream<Duration> get onDurationChanged =>
      _audioPlayerDataSource.onDurationChanged;

  @override
  Stream<Duration> get onPositionChanged => throw UnimplementedError();

  @override
  Future<void> release() async => await _audioPlayerDataSource.release();

  @override
  Stream<void> get onPlayerComplete => _audioPlayerDataSource.onPlayerComplete;

  @override
  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayerDataSource.onPlayerStateChanged;

  @override
  Future<Duration?> getDuration() => _audioPlayerDataSource.getDuration();

  @override
  Future<Duration?> getPosition() => _audioPlayerDataSource.getPosition();
}

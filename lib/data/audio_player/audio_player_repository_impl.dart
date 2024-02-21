import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/data/audio_player/data_sources/audio_player_data_source.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@Singleton(as: AudioPlayerRepository)
class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  AudioPlayerRepositoryImpl(this._audioPlayerDataSource);
  final AudioPlayerDataSource _audioPlayerDataSource;

  @override
  Future<void> setAudioSource(List<SongModel> songs) =>
      _audioPlayerDataSource.setAudioSource(songs);

  @override
  Future<void> play() async => await _audioPlayerDataSource.play();

  @override
  Future<void> seek(Duration position, int? index) async =>
      await _audioPlayerDataSource.seek(position, index);

  @override
  Stream<int?> get currentIndexStream =>
      _audioPlayerDataSource.currentIndexStream;

  @override
  int? get currentIndex => _audioPlayerDataSource.currentIndex;

  @override
  Stream<bool> get shuffleModeEnabledStream =>
      _audioPlayerDataSource.shuffleModeEnabledStream;

  @override
  Stream<LoopMode> get loopModeStream => _audioPlayerDataSource.loopModeStream;

  @override
  Future<void> pause() async => await _audioPlayerDataSource.pause();

  @override
  Future<void> stop() async => await _audioPlayerDataSource.stop();

  @override
  Future<void> seekNext() => _audioPlayerDataSource.seekNext();
  @override
  Future<void> seekPrevious() => _audioPlayerDataSource.seekPrevious();

  @override
  Future<void> setLoopMode(LoopMode mode) =>
      _audioPlayerDataSource.setLoopMode(mode);

  @override
  Future<void> setShuffleModeEnabled({required bool enabled}) =>
      _audioPlayerDataSource.setShuffleModeEnabled(enabled: enabled);

  @override
  LoopMode get loopMode => _audioPlayerDataSource.loopMode;

  @override
  bool get shuffleModeEnabled => _audioPlayerDataSource.shuffleModeEnabled;

  @override
  PlayerState get playerState => _audioPlayerDataSource.playerState;

  @override
  AudioSource? get audioSource => _audioPlayerDataSource.audioSource;

  @override
  Stream<Duration?> get onDurationChanged =>
      _audioPlayerDataSource.onDurationChanged;

  @override
  Stream<Duration> get onPositionChanged =>
      _audioPlayerDataSource.onPositionChanged;

  @override
  Future<void> dispose() async => await _audioPlayerDataSource.dispose();

  @override
  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayerDataSource.onPlayerStateChanged;

  @override
  Duration? getDuration() => _audioPlayerDataSource.getDuration();

  @override
  Duration? getPosition() => _audioPlayerDataSource.getPosition();
}

import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class SeekAudioUseCase {
  const SeekAudioUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Future<void> call(Duration position) async =>
      await _audioPlayerRepository.seekTo(position);
}

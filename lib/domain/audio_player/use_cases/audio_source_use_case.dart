import 'package:audioplayers/audioplayers.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class AudioSourceUseCase {
  const AudioSourceUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Source? call() => _audioPlayerRepository.audioSource;
}

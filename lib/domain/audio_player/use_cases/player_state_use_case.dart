import 'package:audioplayers/audioplayers.dart';
import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class PlayerStateUseCase {
  const PlayerStateUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  PlayerState call() => _audioPlayerRepository.playerState;
}

import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class GetLoopModeUseCase {
  const GetLoopModeUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  LoopMode call() => _audioPlayerRepository.loopMode;
}

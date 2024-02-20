import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class SetLoopModeUseCase {
  const SetLoopModeUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Future<void> call(LoopMode loopMode) async =>
      await _audioPlayerRepository.setLoopMode(loopMode);
}

import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class StopAudioUseCase {
  const StopAudioUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Future<void> call() async => await _audioPlayerRepository.stop();
}
